(function ($) {
    /**
     * @param options
     *
     * Options list:
     *
     * urlColumnData             - required,
     * urlDataTable              - required,
     * checkedUrl                - required,
     * checkedCounterSelector    - selector to object with number of checked rows,
     * counterSelector           - selector to object with time of query (s) ,
     * deleteUrl                 - url for delete row,
     * idName                    - Name of primary key (id or obj_id)
     * checkboxes                - Checkboxes. Def: false
     * extRowMenu: [{            - Массив с дополнительными пунктами меню записи
     *     title,                - Тайтл меню
     *     cb(id)                - Callback on click
     *     conditionShow         - Condition show
     * }]
     * editForm:{                - optional. Params of edit row
     *     url,                  - url to form
     *     title,                - title of form
     *     type                  - can be 'modal' or 'page'. Default: 'modal'
     * }
     * createForm:{              - optional. Params of create row
     *     url,                  - url to form
     *     title,                - title of form
     *     type                  - can be 'modal' or 'page'. Default: 'modal'
     * }
     * detailForm:{              - optional. Params of create row
     *     url,                  - url to form
     *     title,                - title of form
     *     type                  - can be 'modal' or 'page'. Default: 'modal'
     * }
     *
     * @constructor
     */
    $.fn.DataTableWrapperExt = function (options) {
        var element = this;

        element.css('overflow-x', 'scroll');
        var id = element.attr('id');
        if (!id) {
            id = parseInt(Math.random() * 1000000000);
            element.attr('id', id);
        }
        var idTable = id + '-datatable';
        var idSelector = "#" + id;
        var idTableSelector = "#" + idTable;
        var columnsData;

        options = options || {};

        options.checkboxes = options.checkboxes || false;
        options.dtFilters = options.dtFilters || false;
        options.dtTheadButtons = options.dtTheadButtons || false;
        options.select2Input = options.select2Input || false;

        var reqOptions = [
            'urlColumnData',
            'urlDataTable',
            'checkedUrl'
        ];

        for (var i = 0; i < reqOptions.length; i++) {
            if (typeof options[reqOptions[i]] == 'undefined') {
                console.error(reqOptions[i] + " option is required");
            }
        }

        var reportObjects = {query: {}, response: {}, request: {}};
        var conditionTable = {};
        var wrapper;
        var datatable;

        var sortObject = options.sortDefault;

        var checkedIds = {};
        var colVis = {};
        var tableObjectName = options.tableDefault;

        function createTable(col) {
            var result = [];
            var columnsSettings = [];

            if (options.checkboxes) {
                result.push({
                    data: null,
                    defaultContent: '<input class="check-item" name="select-row" type="checkbox">',
                    orderable: false
                });
                columnsSettings.push({
                    aTargets: [0],
                    sTitle: '<input class="data_table_check_item" name="select-row" data-id-row="checkAll" type="checkbox">',
                    mRender: function (data, type, full) {
                        return '<input type=\"checkbox\" class ="data_table_check_item" name="select-row" ' + (checkNode(full[options.idName]) ? 'checked' : '') + ' value="true" data-id-row=' + full[options.idName] + '>';
                    }
                });
            }

            result.push({
                data: null,
                visible: options.dtTheadButtons,
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
                mRender: function (data, type, full) {
                    var buttons = [];
                    var url;
                    if (data[options.idName]) {
                        if (options.editForm) {
                            url = options.editForm.url.replace(':id', data[options.idName]);
                            var typeUrl = options.editForm.type || 'modal';
                            buttons.push(['<li>',
                                '<a href="' + url + '" data-btn-type="edit-' + typeUrl + '">Изменить</a>',
                                '</li>'
                            ].join(''));
                        }
                        if (options.extRowMenu) {
                            $.each(options.extRowMenu, function (key, menu) {
                                if (menu.conditionShow) {
                                    var cond = eval(menu.conditionShow);
                                    if (!cond) {
                                        return true;
                                    }
                                }

                                if (menu.renderRow) {
                                    buttons.push(menu.renderRow(data));
                                } else {
                                    buttons.push(['<li>',
                                        '<a href="javascript:;" data-btn-type="ext-menu-row" data-number="' + key + '" data-id="' + data[options.idName] + '">' + menu.title + '</a>',
                                        '</li>'
                                    ].join(''));
                                }
                            })
                        }

                        if (options.detailForm) {
                            $.each(options.detailForm, function (key, menu) {

                                buttons.push(['<li>',
                                    '<a href="javascript:;" data-btn-type="ext-menu-row" data-number="' + key + '" data-id="' + data[options.idName] + '">' + menu.title + '</a>',
                                    '</li>'
                                ].join(''));
                            })
                        }

                        if (options.deleteUrl) {
                            url = options.deleteUrl.replace(':id', data[options.idName]);
                            buttons.push(['<li>',
                                '<a href="' + url + '" data-btn-type="delete">Удалить</a>',
                                '</li>'
                            ].join(''));
                        }
                    }
                    if (buttons.length == 0) {
                        return '';
                    }
                    return [
                        '<div class="btn-group"><button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">',
                        '<span class="fa fa-gear"></span>',
                        '<span class="sr-only">Toggle Dropdown</span>',
                        '</button>',
                        '<ul data-id="list" class="dropdown-menu" role="menu">' + buttons.join('') + '</ul></div>'
                    ].join('');
                }
            });
            datatable = $(idTableSelector).DataTable({
                processing: true,
                serverSide: true,
                searching: false,
                dom: '<"top"flp>rt<"bottom"i><"clear"><"bottom"p>',
                ajax: {
                    url: options.urlDataTable,
                    type: "GET",
                    data: function (d) {
                        d['columns'] = prepareCondition(d).columns;
                        var filters = getUrlFIlters();

                        $.each(filters, function (key, val) {
                            for (var i in d['columns']) {
                                if (d['columns'][i]['dataCol'] == key) {
                                    d['columns'][i]['filterValue'] = val;
                                    d['columns'][i]['filterCond'] = '=';
                                    d['columns'][i]['filterType'] = 'int4';
                                    return;
                                }
                            }

                            d['columns'].push({
                                dataCol: key,
                                filterValue: val,
                                filterCond: '=',
                                filterType: 'int4'
                            });
                        });

                        d.objdb = tableObjectName;
                        conditionTable = d;
                        addReportObjects('request', 'table', d);
                    },
                    complete: function (d) {
                        addReportObjects('query', 'q2', d.responseJSON.debug.query[0].data);
                        addReportObjects('query', 'q3', d.responseJSON.debug.query[1].recordsTotal);

                        delete d.responseJSON.debug;
                        addReportObjects('response', 'r1', d.responseJSON);
                        counter();
                    }
                },
                columns: result,
                aoColumnDefs: columnsSettings,
                drawCallback: function (settings) {
                    var last = null;

                    $(idTableSelector).find('td input[name=select-row]').on('click', checkedChange);
                    $(idTableSelector + ' a[data-btn-type=edit-modal]').on('click', startEdit);

                    $(idTableSelector + ' a[data-btn-type=delete]').on('click', deleteRow);
                    $(idTableSelector + ' a[data-btn-type=ext-menu-row]').on('click', function (e) {
                        var id = $(this).attr('data-id');
                        var num = $(this).attr('data-number');
                        options.extRowMenu[parseInt(num)].cb(id);
                    });
                },
                initComplete: function (settings, json) {
                    $(idTableSelector).find('th input[data-id-row=checkAll]').on('click', checkedChange);

                    $(idSelector + ' button[data-btn-type=refresh]').on('click', function () {
                        datatable.ajax.reload();
                    });
                    $(idSelector + ' a[data-btn-type=create-modal]').on('click', startCreate);

                    if (options.dtFilters) {
                        $(idTableSelector).prepend(addFilter(col));
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
            var var_total = '';
            var columnsVisibility = '';

            item.forEach(function (item, i, data) {
                var filterOop = '';
                var filterValues = '';
                if (item.cd) {
                    item.cd.forEach(function (item, i, data) {
                        filterOop = filterOop + '<option>' + item + '</option>';
                    });
                }
                if (item.cdi) {
                    item.cdi.forEach(function (item2, i, data) {
                        filterValues = filterValues + '<option>' + item2 + '</option>';
                    });
                }

                colVis[item.data] = item.visible;
                var check = item.visible ? 'checked' : '';

                if (item.visible) {
                    if (options.select2Input && item.type == 'text'){
                        var_total = var_total + '<th><select multiple class="sSelect2" style="width: 50px;" type="' + item.type + '" placeholder="' + item.title + '" name="input" data-column="'+item.data+'"></select></th>'
                    }
                    /*$(idTableSelector + ' .input-group').find(":selected").each(function () {*/
                    else {
                        var_total = var_total + '<th>' +
                            '<div class="input-group">' +
                            '<div class="input-group-btn">' +
                            '<select class="btn btn-default btn-sm dropdown-toggle">' + filterOop + '' +
                            '</select>' +
                            ' </div>' +
                            '<input type="' + item.type + '" style ="width: 70px" class="form-control input-sm" data-column="' + item.data + '" placeholder="' + item.title + '"></div></th>';
                    }
                    }
                columnsVisibility = columnsVisibility + '<li><a href="#" class="small" data-data="' + item.data + '" tabIndex="-1"><input ' + check + ' type="checkbox"/>&nbsp;' + item.title + '</a></li>';
            });

            $('[data-type=visible-columns]').html(columnsVisibility);

            var thCheckboxes = '';

            if (options.checkboxes) {
                thCheckboxes = '<th>' +
                    '<button type="button" id = "checked_counter" disabled class="btn btn-default">0' +
                    '</button></th>';
            }

            var theadObject = '';
            if (options.dtTheadButtons) {
                theadObject = '<th>' +
                    '<div class="input-group">' +
                    '<div class="input-group-btn">' +
                    '<button type="button" class="btn btn-default btn-sm" onclick="wrapper.getDataTable().ajax.reload()">Search</button></div>' +
                    '<button type="button" class="btn btn-default btn-sm" onclick="wrapper.rebuildTable()">Clear</button></div>' +
                    ' </th> ';
            };

            $(idTableSelector).prepend('<thead><tr>' + thCheckboxes + theadObject
                + var_total + ' </tr></thead>');

            $('[data-type=visible-columns] a').on('click', function (event) {

                var $target = $(event.currentTarget),
                    val = $target.attr('data-data'),
                    inp = $target.find('input');

                if (colVis[val] == true) {
                    colVis[val] = false;

                    setTimeout(function () {
                        inp.prop('checked', false)
                    }, 0);
                } else {
                    colVis[val] = true;
                    setTimeout(function () {
                        inp.prop('checked', true)
                    }, 0);
                }

                $(event.target).blur();

                return false;
            });

            $(idTableSelector + ' th input[type=int4]').each(function (data) {
                $(this).attr('maxlength', '7');
                $(this).bind("change keyup input click", function () {
                    if (this.value.match(/[^0-9]/g)) {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    }
                });
            });

            $(".sSelect2").select2({
                placeholder: "Поиск",
                minimumInputLength: 3,
                width: "15em",
                ajax: {
                    url: "/admin/pg/pg/txtsrch",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    data: function (srch) {

                        return Object.assign({}, srch, {
                            'objdb': tableObjectName,
                            'col': ($(this).attr('data-column'))
                        });
                    },
                    processResults: function (data, page) {
                        var ob = [];

                        $.each(data, function (key, value) {
                            ob.push({'id': value, 'text': value});
                        });
                        return {results: ob};
                    }
                }
            });

            $('.sSelect2').on('select2:close', function (evt) {
                datatable.ajax.reload();
            });

            var today = moment().add(1, 'days').format('YYYY.MM.DD');

            var selectColStamp = idTableSelector + ' th input[type=timestamp],' + idTableSelector + ' th input[type=timestamptz],' + idTableSelector + ' th input[type=date]';
            $(selectColStamp).daterangepicker({
                startDate: moment().subtract(29, 'days'),
                endDate: moment(),
                locale: {format: 'YYYY.MM.DD'},
                autoUpdateInput: false,
                ranges: {
                    'Today': [moment().format('YYYY.MM.DD'), today],
                    'Yesterday': [moment().subtract(1, 'days').format('YYYY.MM.DD'), moment().format('YYYY.MM.DD')],
                    'Last 7 Days': [moment().subtract(6, 'days').format('YYYY.MM.DD'), today],
                    'Last 30 Days': [moment().subtract(29, 'days'), today],
                    'This Month': [moment().startOf('month'), moment().endOf('month').add(1, 'days').format('YYYY.MM.DD')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month').add(1, 'days').format('YYYY.MM.DD')]
                }
            });

            $(selectColStamp).on('apply.daterangepicker', function(ev, picker) {
                $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
            });

            $(selectColStamp).on('cancel.daterangepicker', function(ev, picker) {
                $(this).val('');
            });
        }

        function prepareCondition(d) {
            var cd = [];
            d.order = sortObject;

            conditionTable['columns'] = [];

            $(idTableSelector + ' .input-group').find(":selected").each(function () {
                cd.push({cd: this.innerHTML});
            });
            var columns = [];

            // Get searching field type and input value
            $(idTableSelector + ' input[data-column]').each(function (data) {
                var filterCond = cd[data].cd.replace('&lt;', '<').replace('&gt;', '>');
                var filterValue = ($(this).val());
                var filterType;
                var filterData;

                if (filterCond != 'X' && filterValue != '') {
                    filterType = $(this).attr('type');
                    filterData = $(this).attr('data-column');
                    filterValue = ($(this).val());
                    filterCond = cd[data].cd.replace('&lt;', '<').replace('&gt;', '>');

                    columns.push({
                        dataCol: filterData,
                        filterType: filterType,
                        filterValue: filterValue,
                        filterCond: filterCond
                    });
                }
            });
            // Get searching field type and input value

            $('.sSelect2').each(function (data) {

                var items = $(this).select2('data');
                var filterData = $(this).attr('data-column');
                var filterValue = [];

                items.forEach(function (item) {
                    if (item.text) {
                        filterValue.push(item.text);
                    }
                });

                if (filterValue.length > 0) {

                    columns.push({
                        dataCol: filterData,
                        filterType: 'text',
                        filterValue: filterValue.join(),
                        filterCond: 'in'
                    });
                }
            });

            conditionTable['columns'] = columns;

            return conditionTable;
        }

        function deleteRow(e) {
            e.preventDefault();
            var url = $(this).attr('href');
            var button = $('.modal-delete button[data-btn-type=make-delete]');
            button.attr('data-url', url);

            $('.modal-delete').modal('show');
        }

        function makeDelete(e) {
            e.preventDefault();

            var button = $('.modal-delete button[data-btn-type=make-delete]');
            var url = button.attr('data-url');

            $.ajax({
                url: url,
                type: 'DELETE',
                success: function (result) {
                    datatable.ajax.reload();
                },
                complete: function () {
                    button.attr('data-url', '');
                    $('.modal-delete').modal('hide');
                }
            });
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

        function modalForm(url, title, afterLoadForm, afterSuccessful) {
            var app_id = url;

            showModal(url, title, function (modal) {
                var form = modal.find('form');

                if (afterLoadForm) {
                    afterLoadForm(form);
                }

                console.log('Will send to ', url);
                var formOptions = {
                    url: url,
                    success: function (data, statusText, xhr, form) {
                        if (afterSuccessful) {
                            afterSuccessful(data, statusText, xhr, form);
                        }
                        modal.modal('hide');
                    },
                    error: function (xhr) {
                        if (xhr.responseJSON.errors) {
                            $.each(xhr.responseJSON.errors, function (key, msg) {
                                $.jGrowl(msg, {
                                    header: 'Ошибка',
                                    theme: 'alert-danger',
                                    life: 5000
                                });
                            });
                        }
                    },
                    resetForm: true
                };
                $(form).ajaxForm(formOptions);
            });
        }

        function showModal(url, title, fn) {
            var modalFormContainer = $('#modal-form-container');
            if (!modalFormContainer.length) {
                modalFormContainer = $("<div id='modal-form-container'></div>");
                $('body').append(modalFormContainer);
            }
            modalFormContainer.empty();

            modalFormContainer.load(url, function () {
                var modalForm = modalFormContainer.find('.modal-form');
                modalForm.find('.modal-title').html(title);
                modalForm.modal('show');

                if (fn) {
                    fn(modalForm);
                }
            });
        }

        function initTable(visCol) {
            return $.ajax({
                method: "GET",
                url: options.urlColumnData,
                data: {
                    visCol: visCol,
                    objdb: tableObjectName
                }
            }).done(function (data) {
                element.html('');

                var simple_checkbox = function (data, type, full, meta) {
                    var is_checked = data == true ? "checked" : "";
                    return '<input type="checkbox" class="checkbox" ' +
                        is_checked + '  disabled/>';
                }
                if (data.columns) {
                    for (var i = 0; i < data.columns.length; i++) {
                        if (data.columns[i]["type"] == "bool") {
                            data.columns[i].render = simple_checkbox;
                        }
                    }
                }
                columnsData = data;

                var buttons = [];

                
            /*    buttons.push([
                    ' <button type="button" class="btn btn-default" data-type="rebuild">RebuildTable</button>',
                    ' <button type="button" class="btn btn-default" data-type="export_excel">ExportExcel</button>',
                    ' <div class="dropdown" style="display: inline-block"><button type="button" id="visible-columns" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-cog"></span> <span class="caret"></span></button>',
                    '<ul class="dropdown-menu" data-type="visible-columns" aria-labelledby="visible-columns">',
                    '</ul></div>'
                ].join(''));*/

                var htmlElements = [
                    '<div>',
                    buttons.join(''),
                    '</div>',
                    '<table id="' + idTable + '" class="table table-striped table-bordered" cellspacing="0" width="100%">' +
                    ' </table>'
                ];
                
                element.prepend(htmlElements.join(''));

                addReportObjects('query', 'q1', data.createColumns);

                createTable(data);

                $('[data-type=rebuild]').click(function () {
                    wrapper.rebuildTable();
                });

                $('[data-type=export_excel]').click(function () {
                    if (Object.keys(checkedIds).length > 0) {
                        GetCsvDataTable();
                    }
                });

                if (options.deleteUrl) {
                    $('body').append(confirmDeleteModal);
                    $('.modal-delete button[data-btn-type=make-delete]').on('click', makeDelete);
                }
            })
        }

        function checkedChange(e) {
            var cell = $(e.target);

            var state = cell.prop('checked');
            var id = cell.attr('data-id-row');

            console.log(conditionTable);
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

        function addReportObjects(type, key, object) {
            reportObjects[type][key] = object;
        }

        function checkNode(id) {
            return checkedIds[id] == true;
        }

        function counter() {
            rebuildCounter('query', options.queryCounterSelector);
            rebuildCounter('request', options.requestCounterSelector);
            rebuildCounter('response', options.responseCounterSelector);
        }

        function rebuildCounter(objectRep, id) {
            var obj = reportObjects[objectRep];
            var count = 0;
            var time = 0.0;
            var result = '';

            Object.keys(obj).forEach(function (item1) {
                if (objectRep == 'query') {
                    time += obj[item1]['time'];
                }
                count++;
            });

            result = count;

            if (time) {
                result = count + ' / ' + time.toPrecision(2) + ' sec';
            }

            $(id).html(result);
        }

        wrapper = {
            nodeCount: function () {
                return Object.keys(checkedIds).length;
            },
            getReportObjects: function () {
                return reportObjects;
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
            rebuildS2Columns: function (data) {
                tableObjectName = data;
                initTable();
            },
            exportToExcel: function () {
                GetCsvDataTable();
            },
            modalForm: modalForm
        };

        var confirmDeleteModal = [
            '<div class="modal modal-danger modal-delete fade">',
            '<div class="modal-dialog">',
            '<div class="modal-content">',
            '<div class="modal-header">',
            '<button type="button" class="close" data-dismiss="modal" aria-label="Close">',
            '<span aria-hidden="true">×</span></button>',
            '<h4 class="modal-title">ВНИМАНИЕ!!!</h4>',
            '</div>',
            '<div class="modal-body">',
            '<p>Вы уверены что хотите удалить эту запись?</p>',
            '</div>',
            '<div class="modal-footer">',
            '<button type="button" class="btn btn-outline pull-left" data-dismiss="modal">Отмена</button>',
            '<button type="button" class="btn btn-outline" data-btn-type="make-delete">Удалить</button>',
            '</div>',
            '</div>',
            '</div>',
            '</div>'
        ];
        confirmDeleteModal = confirmDeleteModal.join('');

        initTable();
        
        function GetCsvDataTable() {
            $.get(options.urlColumnData, {fieldIds: options.idName,"ids":Object.keys(checkedIds).join(','),objdb:tableObjectName}, function (data) {
                columns = data.columns;

                $.get(options.urlDataTable, {fieldIds: options.idName,"ids":Object.keys(checkedIds).join(','),objdb:tableObjectName}, function (data) {
                    JSONToCSVConvertor(data.data,'ExportTest',true, columns);
                });

            });
        }

        function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel, Columns) {
            //If JSONData is not an object then JSON.parse will parse the JSON string in an Object
            var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;

            var CSV = '';
            //Set Report title in first row or line

            // CSV += ReportTitle + '\r\n\n';

            var title = {};
            Object.keys(Columns).forEach(function(key) {
                title[Columns[key].data] = Columns[key].title;
            });


            //This condition will generate the Label/Header
            if (ShowLabel) {
                var row = "";

                //This loop will extract the label from 1st index of on array
                for (var index in arrData[0]) {
                    //Now convert each value to string and comma-seprated
                    row += title[index] + ',';
                }

                row = row.slice(0, -1);

                //append Label row with line break
                CSV += row + '\r\n';
            }


            //1st loop is to extract each row
            for (var i = 0; i < arrData.length; i++) {
                var row = "";
                //2nd loop will extract each column and convert it in string comma-seprated
                for (var index in arrData[i]) {
                    row += '"' + arrData[i][index] + '",';
                }

                row.slice(0, row.length - 1);

                //add a line break after each row
                CSV += row + '\r\n';
            }

            if (CSV == '') {
                alert("Invalid data");
                return;
            }

            //Generate a file name
            var fileName = "MyReport_";
            //this will remove the blank-spaces from the title and replace it with an underscore
            fileName += ReportTitle.replace(/ /g,"_");

            //Initialize file format you want csv or xls
            var uri = 'data:text/csv;charset=utf-8,' + encodeURI(CSV);

            // Now the little tricky part.
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension

            //this trick will generate a temp <a /> tag
            var link = document.createElement("a");
            link.href = uri;

            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            link.download = fileName + ".csv";

            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        return wrapper;
    };

    jQuery.fn.ForceNumericOnly =
        function () {
            return this.each(function () {
                $(this).keyup(function (e) {
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

    function urlParamEncode(src) {
        return encodeURIComponent(Base64.encode(JSON.stringify(src)));
    }

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

    function syntaxHighlight(json) {
        if (typeof json != 'string') {
            json = JSON.stringify(json, undefined, 2);
        }
        json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
            var cls = 'number';
            if (/^"/.test(match)) {
                if (/:$/.test(match)) {
                    cls = 'key';
                } else {
                    cls = 'string';
                }
            } else if (/true|false/.test(match)) {
                cls = 'boolean';
            } else if (/null/.test(match)) {
                cls = 'null';
            }
            return '<span class="' + cls + '">' + match + '</span>';
        });
    }
})(jQuery);


