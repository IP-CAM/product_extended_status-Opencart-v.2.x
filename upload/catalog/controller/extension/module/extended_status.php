<?php

class ControllerExtensionModuleExtendedStatus extends Controller {
    private $holidays = array();

    public function index( &$data = array() ) {
        $this->load->language('extension/module/extended_status');
        $this->holidays = $this->config->get('extended_status_holiday');

        if( isset($data['stock_status_id'])
            && $this->config->get('extended_status_custom')
            && ( $custom_status = $this->config->get('extended_status_custom')[$data['stock_status_id']] ) ) {
            $data['stock'] = $custom_status['name'];
            $data['module_name'] = $this->config->get('extended_status_name') ? $this->config->get('extended_status_name') : '';

            if( $i = $this->checkDateToHolidays(0) ) {
                $current_day_increment = $i;
            } elseif( $this->config->get('extended_status_time') && $this->compareTime(date('H:i'), $this->config->get('extended_status_time')) ) {
                $current_day_increment = $this->checkDateToHolidays(1);
            } else {
                $current_day_increment = 0;
            }


            $data['deliveries'] = array();

            foreach( $custom_status['deliveries'] as $delivery ) {
                if( $delivery['day_job'] !== '' ) {
                    if( $current_day_increment && $delivery['day_holiday'] !== '' ) {
                        $days = explode('+', $delivery['day_holiday']);
                    } else {
                        $days = explode('+', $delivery['day_job']);
                    }

                    $day_from = $this->checkDateToHolidays($current_day_increment + (int)$days[0], '$day_from');
                    $month_from = date('n', strtotime('+' . ( $day_from ) . ' day'));

                    if( count($days) > 1 && $days[1] > 0 ) {
                        $day_to = $this->checkDateToHolidays(( $day_from + (int)$days[1] ));
                    } else {
                        $day_to = 0;
                    }

                    if( $day_from === 0 ) {
                        $day_from = $this->language->get('today');
                        if( $day_to === 1 ) {
                            $day_to = $this->language->get('tomorrow');
                        }
                    } elseif( $day_from === 1 ) {
                        $day_from = $this->language->get('tomorrow');
                        if( $day_to === 1 ) {
                            $day_to = 0;
                        }
                    }

                    if( $day_to ) {
                        $month_to = date('n', strtotime('+' . $day_to . ' day'));

                        if( is_numeric($day_from) ) {
                            $day_from = date('j', strtotime('+' . $day_from . ' day'));
                        }

                        if( $month_from === $month_to && is_numeric($day_to) ) {
                            $date = sprintf($this->language->get('from_to_day'), $day_from, date('j', strtotime('+' . $day_to . ' day')), $this->language->get('month_' . $month_from));
                        } elseif( $month_from === $month_to && is_string($day_to) ) {
                            $date = sprintf($this->language->get('from_to_day_str'), $day_from, $this->language->get('month_' . $month_from), $day_to, $this->language->get('month_' . $month_to));
                        } else {
                            $date = sprintf($this->language->get('from_to_month'), $day_from, $this->language->get('month_' . $month_from), $day_to, $this->language->get('month_' . $month_to));
                        }
                    } else {
                        if( is_string($day_from) ) {
                            $date = $day_from;
                        } else {
                            $date = sprintf($this->language->get('from_day'), date('j', strtotime('+' . $day_from . ' day')), $this->language->get('month_' . $month_from));
                        }
                    }
                } else {
                    $date = false;
                }

                $data['deliveries'][] = array(
                    'date'  => $date,
                    'title' => $delivery['text'],
                    'cost'  => $delivery['cost'],
                );
            }

            return $this->load->view('extension/module/extended_status', $data);
        }

        return '';
    }

    protected function compareTime( $current_time, $setting_time ) {
        return ( (float)str_replace(':', '.', $current_time) > (float)str_replace(':', '.', $setting_time) );
    }

    protected function checkDateToHolidays( $i = 0) {
        while( strpos(',' . $this->holidays[date('n', strtotime('+' . $i . ' day'))] . ',', ',' . date('j', strtotime('+' . $i . ' day')) . ',') !== false ) {
            $i++;
        }

        return $i;
    }
}