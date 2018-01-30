
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.1/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.1/js/jquery.dataTables.min.js"></script>


<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css">
<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>


<div id="container" class="panel">
	<select class="js-example-data-array">
		<option value="vw_pg_stat_activity" selected="selected">vw_pg_stat_activity</option>
	</select>
	<button type="button" class="btn btn-default" onclick="datatable.ajax.reload()">Refresh</button>
</div>

<div id = 'view_container'></div>

<script>

	var table = 'vw_pg_stat_activity';
	var datatable;

	InitTableProp('vw_pg_stat_activity');

	function InitTableProp(table) {
		return $.ajax({
			method:"GET",
			url: "column.php",
			"data": {objdb : table}
		}).done(function(data) {
			document.getElementById("view_container").innerHTML = null;
			$( "#view_container").prepend('<table id="example" class="display cellspacing="0" width="100%"> </table>');
			col = JSON.parse(data).columns;
			TableThead(col);
			CreateTable(col,table);
		})
	};

	function CreateTable(col,table){
		datatable = $('#example').DataTable({
			"serverSide": true,
			"searching": false,
			"pageLength": 5,
			"dom": '<"top"ifp>rt<"bottom"i><"clear">',
			"ajax": {
				"url": "field.php",
				type: "GET",
				"data": function (d) {d.objdb = table;}
			},
			"columns": col
		})
	};

	function TableThead(columns) {
		var header = '';
		columns.forEach(function (item, i, data) {
			header = header  +  '<th>' + item['data'] + '</th>';
		});
		$( "#example").prepend('<thead> <tr>' + header + '</thread> </tr> <thead>' + '<thead> <tr></thread> </tr> <thead>');
	}

	var data = [{id: 'vw_pg_locks', text: 'vw_pg_locks' }, { id:'vw_pg_stat_activity', text: 'vw_pg_stat_activity' }, { id: 'vw_pg_stat_user_tables', text: 'vw_pg_stat_user_tables' }, { id: 'vw_pg_stat_database', text: 'vw_pg_stat_database' }];

	$(".js-example-data-array").on("select2:select", function (e) {
		table  = e.params.data.text;
		InitTableProp(table);
	});

	$(".js-example-data-array").select2({
		data: data
	})

</script>