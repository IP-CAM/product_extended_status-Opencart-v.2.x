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

            $current_day = (int)date('j');

            if( $this->config->get('extended_status_time') && $this->compareTime(date('H:i'), $this->config->get('extended_status_time')) ) {
                $current_day += 1;
            }

            $current_day = $this->checkDateToHolidays($current_day);


            $data['deliveries'] = array();

            foreach( $custom_status['deliveries'] as $delivery ) {
                if( $delivery['day_job'] ) {
                    if( $delivery['day_holiday'] !== '' && $current_day > (int)date('j') ) {
                        $days = explode('+', $delivery['day_holiday']);
                    } else {
                        $days = explode('+', $delivery['day_job']);
                    }

                    $day_from = $this->checkDateToHolidays(( $current_day + (int)$days[0] ));

                    if( count($days) > 1 ) {
                        $day_to = $this->checkDateToHolidays(( $day_from + (int)$days[1] ));
                    } else {
                        $day_to = 0;
                    }

                    $month_from = date('n', strtotime('+' . $day_from . ' day'));

                    if( $day_to > 0 ) {
                        $month_to = date('n', strtotime('+' . $day_to . ' day'));
                        if( $month_from === $month_to ) {
                            $date = sprintf($this->language->get('from_to_day'), $day_from, $day_to, $this->language->get('month_' . $month_from));
                        } else {
                            $date = sprintf($this->language->get('from_to_month'), $day_from, $this->language->get('month_' . $month_from), $day_to, $this->language->get('month_' . $month_to));
                        }
                    } else {
                        $date = sprintf($this->language->get('from_day'), $day_from, $this->language->get('month_' . $month_from));
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

    protected function checkDateToHolidays( $day ) {
        if( strpos($this->holidays[date('n', strtotime('+' . $day . ' day'))] . ',', $day . ',') !== false ) {
            $day = $this->checkDateToHolidays($day += 1);
        }

        return $day;
    }
}