(function ($) {

    $.fn.DataTableWrapperExt = function (options) {
        var element = this;

        element.css('overflow-x', 'scroll');
        var id = element.attr('id');
        if (!id) {
            id = parseInt(Math.random() * 1000000000);
            element.attr('id', id);
        }
        var idTable = id + '-datatable';
        /*var idSelector = "#" + id;*/
        var idTableSelector = "#" + idTable;
        var columnsData;
        var select2columnsSelector = 'select-' + idTable;
        var tableObjectName = options.tableDefault;

        options = options || {};

        options.checkboxes = options.checkboxes || false;
        options.dtFilters = options.dtFilters || false;
        options.dtTheadButtons = options.dtTheadButtons || false;
        options.select2Input = options.select2Input || false;
        options.is_mat = options.is_mat || false;
        options.displayLength = options.displayLength ? options.displayLength : 20;

        var objectInfo = {objdb: tableObjectName,'dtObj':{},'s2obj':{}};
        var conditionTable = {};
        var wrapper;
        var datatable;
        var sortObject = options.sortDefault;

        var checkedIds = {};
        var colVis = {};

        function createTable(col) {
            var result = [];
            var columnsSettings = [];

            result.push({
                data: null,
                visible: false,
                defaultContent: '',
                orderable: false
            });

            var itt = options.checkboxes + 0;

            col.columns.forEach(function (item, i, data) {
                if (item.visible) {
                    itt++;
                    result[itt] = item;
                }
            });

            columnsSettings.push({
                aTargets: [parseInt(options.checkboxes + 0)],
            });

            datatable = $(idTableSelector).DataTable({
                processing: true,
                serverSide: true,
                searching: false,
                bFilter : false,
                bLengthChange: false,
                pageLength: 5,
                iDisplayLength: options.displayLength,
                dom: '<"top"flp>rt<"bottom"i><"clear"><"bottom"p>',
                ajax: {
                    url: options.urlDataTable,
                    type: "GET",
                    data: function (d) {
                        d['columns'] = prepareCondition(d).columns;
                        var filters = getUrlFIlters();

                        if (options.conditionDefault) {
                            d['columns'] = options.conditionDefault;
                            options.conditionDefault = null;
                        }

                        d.is_mat = options.is_mat;
                        d.objdb = tableObjectName;
                        conditionTable = d;
                    },
                },
                columns: result,
                aoColumnDefs: columnsSettings,
                drawCallback: function (settings) {
                    objectInfo['dtObj'] =  {o:this.api().data().ajax.json(),i:this.api().data().ajax.params()};

                    $('#datatable-data').text('Data:'+ objectInfo.dtObj.o.debug.query[0].data.time);

                    $('#datatable-f-ttl').text('TotalFiltered:' +objectInfo.dtObj.o.debug.query[1].recordsFiltered.time);
                    $('#datatable-ttl').text('Total:' + objectInfo.dtObj.o.debug.query[2].recordsTotal.time);
                },
                initComplete: function (settings, json) {
                    if (options.dtFilters) {
                        addFilter(col);
                    }

                    $(idTableSelector + ' thead th.sorting').click(function () {
                        sortObject = [];

                        var data = (datatable.column(this).dataSrc());
                        var sortedType;
                        var result = $(this).attr('class').split('_', 2)[1];

                        if (!result) {
                            sortedType = 'asc';
                        }
                        else if (result == 'asc') {
                            sortedType = 'desc';
                        }
                        else if (result == 'desc') {
                            sortedType = 'asc';
                        }
                        sortObject = [{'column': data, 'dir': sortedType}];
                    });
                },
                createdRow: function (row, data, index) {
                    if (options.createdRow) {
                        options.createdRow(row, data, index);
                    }
                }
            });
        }

        function getUrlFIlters() {
            var filters = getQueryVariable('filters');
            if (!filters) {
                return {};
            }

            filters = urlParamDecode(filters);

            return filters;
        }

        function addFilter(col) {
            var item = col.columns;
            html ='';
        /**/

            item.forEach(function (item, i, data) {
                v= '';
                if(item.visible) {
                    v = '<th></th>';

                    if (item.is_filter) {
                        if (item.cd[0] == 'select2dynamic') {
                            v = '<th><select multiple class="' + select2columnsSelector + '"  type="' + item.type + '" placeholder="' + item.title + '" name="input" data-column="' + item.data + '"></select></th>';
                        }
                        else if (item.type == 'timestamptz') {
                            v = '<th><input type="' + item.type + '" class="form-control input-sm" data-column="' + item.data + '" placeholder="' + item.title + '"></div></th>';
                        }
                        else if (item.cd) {
                            var option = '';

                            (item.cd).forEach(function(element) {
                                option = option + '<option>'+element+'</option>';
                            });

                          var v = '<th><div class="input-group">'+
                            '<div class="input-group-btn">'+
                            '<select class="btn btn-default">'+ option +
                            '</select>'+
                            '</div>'+
                            '<input type="' + item.type + '" filter-cond="=" class="form-control input-sm" data-column="'+ item.data +'" placeholder="'+ item.title +'">'+
                            '</div></th>';
                           /*v = '<th><div class="input-group"><div class="input-group-btn"><select class="btn btn-default btn-sm dropdown-toggle"><option>=</option><option>!=</option><option>&lt;</option><option>&gt;</option><option>&lt;=</option><option>&gt;=</option></select> </div><input type="int4" style="width: 70px" class="form-control input-sm" data-column="id" placeholder="id"></div></th>';*/
                        }
                    }
                }
                html = html + v;
            });

            $(idTableSelector).prepend('<thead><tr>"' + html + '"</tr></thead>');

            $('th .input-group').each(function() {
                $(this).change(function() {
                    var cond;
                    $(this).find(":selected").each(function (d) {
                        cond  = this.innerHTML;
                    });

                    $(this).find("[filter-cond]").each(function (d) {
                        $(this).attr('filter-cond',cond);
                    });
                });
            });

            $(idTableSelector + ' th input[type=int4]').each(function (data) {
                $(this).attr('maxlength', '7');
                $(this).bind("change keyup input click", function () {
                    if (this.value.match(/[^0-9]/g)) {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    }
                });
            });

            $('.' + select2columnsSelector).each(function (data) {
                var col = ($(this).attr('data-column'));
                var type = $(this).attr('type')

                $(this).select2({
                    placeholder: "",
                    minimumInputLength: type == 'int4' ? 1 : 3,
                    width: '100%',
                    dropdownAutoWidth: true,
                    language: {
                        inputTooShort: function (args) {
                            return "";
                        },
                        noResults: function () {
                            return "Не найдено";
                        },
                        searching: function () {
                            return "Поиск...";
                        },
                        errorLoading: function () {
                            return "";
                        },
                    },
                    ajax: {
                        url: options.urlSelect2,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (srch) {
                            return Object.assign({}, srch, {
                                'objdb': tableObjectName,
                                'col': col,
                                'type': type
                            });
                        },
                        processResults: function (data, page) {
                            var ob = [];

                            objectInfo['s2obj']= {o:data,i:{'objdb': tableObjectName, 'col': col, 'type': type}};

                            if(objectInfo.s2obj['o'])
                                $('#select2-query').text('Select2:' + objectInfo.s2obj.o.time);
                            else
                                $('#select2-query').text('');

                            if(ob.push) {
                                $.each(data.rs, function (key, value) {
                                    ob.push({'id': value, 'text': value});
                                });
                            }
                            return {results: ob};
                        }
                    }
                });
            });

            $('.' + select2columnsSelector).on('select2:close', function (evt) {
                datatable.ajax.reload();
            });

            var selectColStamp = idTableSelector + ' th input[type=timestamp],' + idTableSelector + ' th input[type=timestamptz],' + idTableSelector + ' th input[type=date]';

            var start = moment().subtract(29, 'days');
            var end = moment();

            $(selectColStamp).daterangepicker({
                startDate: start,
                endDate: end,
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                }
            });

            $(selectColStamp).on('apply.daterangepicker', function(ev, picker) {
                $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
                datatable.ajax.reload();
            });

            $(selectColStamp).on('cancel.daterangepicker', function(ev, picker) {
                $(this).val('');
                datatable.ajax.reload();
            });
        }

        function prepareCondition(d) {
            d.order = sortObject;
            conditionTable['columns'] = [];

            var columns = [];

            $(idTableSelector + ' [data-column],th input[type=timestamp],' + idTableSelector + ' th input[type=timestamptz],' + idTableSelector + ' th input[type=date]').each(function (data) {
                var val = $(this).val();
                var filterData = $(this).attr('data-column');
                var filterType = $(this).attr('type');
                var filterCond = $(this).attr('filter-cond');

                if (val) {
                    if (Array.isArray(val)) {
                        columns.push({
                            dataCol: filterData,
                            filterType: filterType,
                            filterValue: val.join(),
                            filterCond: 'in'
                        });
                    }
                    else if(filterCond) {
                        columns.push({
                            dataCol: filterData,
                            filterType: filterType,
                            filterValue: val,
                            filterCond: (filterCond.replace('&lt;', '<')).replace('&gt;', '>')
                        });
                    }
                    else {
                        columns.push({
                            dataCol: filterData,
                            filterType: filterType,
                            filterValue: val,
                            filterCond: 'between'
                        });
                    }
                }
            });

            conditionTable['columns'] = columns;
            return conditionTable;
        };

        function deleteRow(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            var button = $('.modal-delete button[data-btn-type=make-delete]');
            button.attr('data-url', url);

            $('.modal-delete').modal('show');
        }

        function startEdit(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            var title = options.editForm.title || 'Изменить';
            modalForm(url, title);
        }

        function startCreate(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            var title = options.createForm.title || 'Добавить';
            modalForm(url, title);
        }

        function initTable(visCol) {
            if (!options.columns) {
                return $.ajax({
                    method: "GET",
                    url: options.urlColumnData,
                    data: {
                        visCol: visCol,
                        objdb: tableObjectName
                    }
                }).done(function (data) {
                    CollRender(data);
                });
            }
            else {
                CollRender(options.columns);
            }
        }

        function CollRender(data) {
            data = JSON.parse(data);

            element.html('');

            var simple_checkbox = function (data, type, full, meta) {
                var is_checked = data == true ? "checked" : "";
                return '<input type="checkbox" class="checkbox" ' +
                    is_checked + '  disabled/>';
            };
            moment.lang('ru');
            var pretty_timestamp =
                function (data, type, full, meta) {
                    var now = moment.parseZone(data);
                    now = now.format('lll');

                    return now == 'Invalid date' ? '' : now;
                };

            if (data.columns) {
            }
            for (var i = 0; i < data.columns.length; i++) {
                if (data.columns[i]["type"] == "bool") {
                    data.columns[i].render = simple_checkbox;
                }
                if (data.columns[i]["type"] == "timestamptz" || data.columns[i]["type"] == "timestamp" || data.columns[i]["type"] == "date") {
                    data.columns[i].render = pretty_timestamp;
                }
            }
            columnsData = data;

            var buttons = [];

            var htmlElements = [
                '<div>',
                buttons.join(''),
                '</div>',
                '<table id="' + idTable + '" class="table table-striped table-bordered" cellspacing="0" width="100%">' +
                ' </table>'
            ];

            element.prepend(htmlElements.join(''));

            createTable(data);

            $('[data-type=rebuild]').click(function () {
                wrapper.rebuildTable();
            });
        }

        function checkedChange(e) {
            var cell = $(e.target);

            var state = cell.prop('checked');
            var id = cell.attr('data-id-row');

            if (id == 'checkAll') {
                conditionTable['fieldIds'] = options.idName;
                $.get(options.checkedUrl, conditionTable,
                    function (data) {


                        /*data = JSON.parse(data.data);*/

                        data.data.forEach(function (item) {
                            if (state) {
                                checkedIds[item] = state;
                            } else {
                                checkedIds = {};
                            }
                        });
                        cell.prop('checked', state);

                        $(options.checkedCounterSelector).html(wrapper.nodeCount());

                        datatable.rows().each(function (object, index, data) {
                            $(object).find('input.data_table_check_item').prop('checked', state).trigger('change');
                        });
                    }
                );
            } else {
                if (state) {
                    checkedIds[id] = state;
                } else {
                    delete checkedIds[id];
                }
                cell.prop('checked', state);

                $(options.checkedCounterSelector).html(wrapper.nodeCount());
            }
        }


        function checkNode(id) {
            return checkedIds[id] == true;
        }

        wrapper = {
            nodeCount: function () {
                return Object.keys(checkedIds).length;
            },
            getIdDataTableSelector: function () {
                return idTableSelector;
            },
            getCheckedIds: function () {
                return checkedIds;
            },
            getDataTable: function () {
                return datatable;
            },
            rebuildTable: function () {
                return initTable(colVis);
            },
            getJsonInfo: function () {
                return objectInfo;
            },
            clearFilter: function () {

                $(idTableSelector + ' [data-column]').each(function (data) {
                    if ($(this).attr('multiple')){
                        $(this).select2("val", "");
                    }
                    var val = $(this).val();
                    $(this).val('')
                });
                wrapper.getDataTable().ajax.reload()
            },
            rebuildS2Columns: function (data) {
                tableObjectName = data;
                initTable();
            },
        };

        initTable();

        var filters = getUrlFIlters();
        return wrapper;


        function urlParamDecode(src) {
            return JSON.parse(Base64.decode(decodeURIComponent(src)));
        }

        function getQueryVariable(variable) {
            var query = window.location.search.substring(1);
            var vars = query.split("&");
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split("=");
                if (pair[0] == variable) {
                    return pair[1];
                }
            }
            return (false);
        }
    }


    

})(jQuery);




