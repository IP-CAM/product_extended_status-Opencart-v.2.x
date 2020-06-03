<?php echo $header; ?><?php echo $column_left; ?>
    <div id="content">
        <style>
            .table_inpit_group {
                display: flex;
            }
            .help_inputs {
                display: flex;
                justify-content: flex-end;
            }

            .help_inputs > div {
                display: flex;
                align-items: center;
            }

            .help_inputs > div > span:not(.form-control) {
                width: 3rem;
                height: 3rem;
                flex: 0 0 auto;
                margin-left: 1rem;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 1px solid #ddd;
                font-size: 1.2rem;
                font-weight: 600;
            }

            .help_inputs > div:not(:last-child) {
                margin-right: 1rem;
            }

            .help_inputs .form-control {
                width: 8rem;
                flex: 0 0 auto;
            }
            .has-success input.input_day, .has-success span.form-control {
                background: #8fbb6c45;
            }

            .has-error input.input_day, .has-error span.form-control {
                background: #f56b6b5e;
            }

            .has-warning input.input_cost, .has-warning span.form-control {
                background: #f387331c;
            }

            .table_inpit_group input.input_day {
                width: 4rem;
            }

            .table_inpit_group input.input_cost {
                width: 7rem;
                margin-right: .5rem;
            }

            .table_inpit_group span {
                display: flex;
                align-items: center;
                font-size: 14px;
                font-weight: 600;
                padding: 0 .5rem;
            }

            .td_deliveries > div .table_inpit_group {
                margin-bottom: .5rem;
                padding-bottom: .5rem;
                border-bottom: 1px solid #f2f2f2;
            }

            .table_inpit_group .btn {
                min-width: 2.5rem;
            }
        </style>
        <div class="page-header">
            <div class="container-fluid">
                <div class="pull-right">
                    <button type="submit" form="form-extended_status" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary">
                        <i class="fa fa-save"></i></button>
                    <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a>
                </div>
                <h1><?php echo $heading_title; ?></h1>
                <ul class="breadcrumb">
                    <?php foreach( $breadcrumbs as $breadcrumb ) { ?>
                        <li>
                            <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
                        </li>
                    <?php } ?>
                </ul>
            </div>
        </div>
        <div class="container-fluid">
            <?php if( $error_warning ) { ?>
                <div class="alert alert-danger">
                    <i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            <?php } ?>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="fa fa-pencil"></i> <?php echo $text_edit; ?>
                    </h3>
                </div>
                <div class="panel-body">
                    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-extended_status" class="form-horizontal">
                        <div class="row">
                            <div class="col-md-8">
                                <table class="table table-condensed table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th width="15%">Old name</th>
                                            <th width="20%">New Name</th>
                                            <th width="65%">Deliveries</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach( $custom_statuses as $stock_status_id => $values ) { ?>
                                            <tr>
                                                <td><?php echo $stock_status_id; ?></td>
                                                <td><?php echo $values['original_name']; ?></td>
                                                <td>
                                                    <input type="text" name="extended_status_custom[<?php echo $stock_status_id; ?>][name]" value="<?php echo $values['name']; ?>" class="form-control input-sm">
                                                </td>
                                                <td class="td_deliveries">
                                                    <div>
                                                        <?php foreach( $values['deliveries'] as $index => $delivery ) { ?>
                                                            <div class="table_inpit_group">
                                                                <input type="text" name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][<?php echo $index; ?>][text]" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][text]" value="<?php echo $delivery['text']; ?>" placeholder="text" class="form-control input-sm">
                                                                <span>[</span>
                                                                <div class="has-success">
                                                                    <input type="text" name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][<?php echo $index; ?>][day_job]" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][day_job]" value="<?php echo $delivery['day_job']; ?>" class="form-control input-sm input_day">
                                                                </div>

                                                                <span>or</span>
                                                                <div class="has-error">
                                                                    <input type="text" name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][<?php echo $index; ?>][day_holiday]" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][day_holiday]" value="<?php echo $delivery['day_holiday']; ?>" class="form-control input-sm input_day">
                                                                </div>
                                                                <span>]</span>
                                                                <div class="has-warning">
                                                                    <input type="text" name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][<?php echo $index; ?>][cost]" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][cost]" value="<?php echo $delivery['cost']; ?>" placeholder="cost" class="form-control input-sm input_cost">
                                                                </div>

                                                                <button type="button" class="btn btn-danger btn-sm" onclick="rebuildIndex($(this).parent());">-</button>
                                                            </div>
                                                        <?php } ?>
                                                    </div>

                                                    <div class="table_inpit_group">
                                                        <input type="text" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][text]" value="" placeholder="text" class="form-control input-sm">
                                                        <span>[</span>
                                                        <div class="has-success">
                                                            <input type="text" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][day_job]" value="" class="form-control input-sm input_day">
                                                        </div>
                                                        <span>or</span>
                                                        <div class="has-error">
                                                            <input type="text" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][day_holiday]" value="" class="form-control input-sm input_day">
                                                        </div>
                                                        <span>]</span>
                                                        <div class="has-warning">
                                                            <input type="text" data-name="extended_status_custom[<?php echo $stock_status_id; ?>][deliveries][index][cost]" value="" placeholder="cost" class="form-control input-sm input_cost">
                                                        </div>
                                                        <button type="button" class="btn btn-success btn-sm js_add">+</button>
                                                    </div>

                                                </td>
                                            </tr>
                                        <?php } ?>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="4" class="text-right">
                                                <?php echo $current_time; ?>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                                <div class="help_inputs">
                                    <div class="has-success">
                                        <span class="form-control"></span>
                                        <span data-toggle="tooltip" data-title="<?php echo $help_success; ?>">?</span>
                                    </div>
                                    <div class="has-error">
                                        <span class="form-control"></span>
                                        <span data-toggle="tooltip" data-title="<?php echo $help_error; ?>">?</span>
                                    </div>
                                    <div class="has-warning">
                                        <span class="form-control"></span>
                                        <span data-toggle="tooltip" data-title="<?php echo $help_warning?>">?</span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="input-module-name" class="col-sm-8 control-label"><?php echo $entry_name; ?></label>
                                    <div class="col-sm-4">
                                        <input type="text" id="input-module-name" name="extended_status_name" value="<?php echo $extended_status_name; ?>" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-10 control-label" for="input-module-time"><?php echo $entry_time; ?></label>
                                    <div class="col-sm-2">
                                        <div class="input-group time">
                                            <input type="text" name="extended_status_time" id="input-module-time" value="<?php echo $extended_status_time; ?>" placeholder="HH:mm" data-date-format="HH:mm" class="form-control"/>
                                            <span class="input-group-btn">
                                                <button type="button" class="btn btn-default">
                                                    <i class="fa fa-calendar"></i>
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <table class="table table-condensed table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th width="15%">Month</th>
                                            <th width="80%">Holiday days</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach( $holiday_days as $month => $holidays ) { ?>
                                            <tr>
                                                <td><?php echo $month; ?></td>
                                                <td><?php echo $holidays['month_text']; ?></td>
                                                <td>
                                                    <input type="text" name="extended_status_holiday[<?php echo $month; ?>]" value="<?php echo $holidays['holidays']; ?>" placeholder="<?php echo $entry_month; ?>" class="form-control input-sm">
                                                </td>
                                            </tr>
                                        <?php } ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
                            <div class="col-sm-10">
                                <select name="extended_status_status" id="input-status" class="form-control">
                                    <?php if( $extended_status_status ) { ?>
                                        <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                        <option value="0"><?php echo $text_disabled; ?></option>
                                    <?php } else { ?>
                                        <option value="1"><?php echo $text_enabled; ?></option>
                                        <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script>
      function rebuildIndex(group) {
        var inputGroup = $(group).parent();
        $(group).remove();
        $(inputGroup).children().each(function(i, group) {
          console.log(group);
          $(group).find('input').each(function(j, input) {
            var name = $(input).data('name').replace('index', i);
            $(input).attr('name', name);
          });
        });
      }

      $('.js_add').on('click', function(event) {
        event.preventDefault();
        var inputGroup = $(this).closest('.table_inpit_group');

        if($(inputGroup).find('input')[0].value === '') {
          alert('Впишите название способа, дни опциональны!');
          return false;
        }

        var index = $(inputGroup).prev().children().length;
        var cloneGroup = $(inputGroup).clone();

        $(cloneGroup).find('input').each(function(i, element) {
          var name = $(element).data('name').replace('index', index);
          $(element).attr('name', name);
        });

        var button = $(cloneGroup).children('button')[0];

        $(button).removeClass('js_add').removeClass('btn-success').addClass('btn-danger').text('-').on('click', function() {
          $(cloneGroup).remove();
          $(inputGroup).prev().children().each(function(i, group) {
            $(group).find('input').each(function(j, input) {
              var name = $(input).data('name').replace('index', i);
              $(input).attr('name', name);
            });
          });
        });

        $(inputGroup).prev().append(cloneGroup);
        $(inputGroup).find('input').val('');
      });

      $('.time').datetimepicker({
        pickDate: false
      });
    </script>
<?php echo $footer; ?>