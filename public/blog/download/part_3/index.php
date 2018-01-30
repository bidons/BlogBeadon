
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.1/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.1/js/jquery.dataTables.min.js"></script>


<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css">
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>

<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.min.js"></script>


<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script type="text/javascript" charset="utf8" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-daterangepicker/2.1.24/daterangepicker.min.css">
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-daterangepicker/2.1.24/daterangepicker.min.js"></script>







<div id="container" class="panel">
	<select class="js-example-data-array">
		<option value="vw_pg_stat_activity" selected="selected">vw_pg_stat_activity</option>
	</select>
	<button type="button" class="btn btn-default" onclick="datatable.ajax.reload()">Refresh</button>
</div>

<div id = 'view_container'></div>

<script>
	
	var datatable;
	var table = 'test_p3';
	getTable();
	InitTableProp(table);

	function InitTableProp(table) {
		return $.ajax({
			method: "GET",
			url: "column.php",
			"data": {objdb: table}
		}).done(function (data) {
			document.getElementById("view_container").innerHTML = null;
			$("#view_container").prepend('<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%"> </table>');
			col = JSON.parse(data);

			addFilter(col);
			TableThead(col);
			CreateTable(col, table);
		})
	};

	function CreateTable(col, table) {
		datatable = $('#example').DataTable({
			"processing": true,
			"serverSide": true,
			"searching": false,
			"dom": '<"top"ifp>rt<"bottom"i><"clear">',
			"ajax": {
				"url": "field.php",
				type: "GET",
				"data": function (d) {
					var cd = [];

					$('#example .input-group').find(":selected").each(function () {
						cd.push({cd: this.innerHTML});
					});

					$('#example .input-group input[data-column]').
					each(function (data) {
						filterType = $(this).attr('type');
						filterValue = ($(this).val());
						filterCond = cd[data].cd.replace('&lt;','<').replace('&gt;', '>');

						d.columns[data].search = {
							value: filterValue,
							cd: filterCond,
							type:filterType
						}
					});
					d.objdb = table;
				}
			},
			"columns": col.columns,
			"columnDefs": [
				{ "width": "15%", "targets": 0 }
			]
		})
	};

	function TableThead(col) {
		var header = '';
		var input = '';

		col.columns.forEach(function (item, i, data) {
			header = header + '<th>' + item['data'] + '</th>';
			input = input + '<th>' + addFilter(item) + '</th>'
		});
		$("#example").prepend('<thead> <tr>' + header + '</thread> </tr> ' +
			'<thead>' + '<thead> <tr>' + input + '</tr> </thread>');

		jQuery.fn.ForceNumericOnly =
			function () {
				return this.each(function () {
					$(this).keydown(function (e) {
						var key = e.charCode || e.keyCode || 0;
						return (
						key == 8 ||
						key == 9 ||
						key == 13 ||
						key == 46 ||
						key == 110 ||
						key == 190 ||
						(key >= 35 && key <= 40) ||
						(key >= 48 && key <= 57) ||
						(key >= 96 && key <= 105));
					});
				});
			};

		$('input[type=int4]').each(function (data) {
			$(this).ForceNumericOnly();
		});

		$('input[type=timestamp]').daterangepicker({
			startDate: moment().subtract(29, 'days'),
			endDate: moment(),
			locale: {format: 'YYYY.MM.DD'},
			ranges: {
				'Today': [moment(), moment()],
				'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
				'Last 7 Days': [moment().subtract(6, 'days'), moment()],
				'Last 30 Days': [moment().subtract(29, 'days'), moment()],
				'This Month': [moment().startOf('month'), moment().endOf('month')],
				'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
			}
		});
	}

	function addFilter(item) {
		var var_item = '';
		if (item.cd) {
			item.cd.forEach(function (item, i, data) {
				var_item = var_item + '<option>'+item+'</option>';
			});
		};
		var_total = '<div class="input-group"> <div class="input-group-btn btn-group"> <select class="btn btn-mini"> <option>X</option>' +
			'' + var_item + ' </select> </div> <input type="'+item.type+'" class="form-control input-sm" data-column="'+item.data +'" placeholder="'+item.title+'"></div>';
		return var_total;

	};
	$(".js-example-data-array").on("select2:select", function (e) {
		table = e.params.data.text;
		InitTableProp(table);
	});

	function getTable() {
		$.ajax({
			method: "GET",
			url: "objectdb.php"
		}).done(function (data) {
			$(".js-example-data-array").select2({
				data: JSON.parse(data)
			});
		});
	};
</script>