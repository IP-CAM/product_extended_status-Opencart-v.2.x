<?php

class ControllerExtensionModuleExtendedStatus extends Controller {
    private $error = array();

    public function index() {
        $this->load->language('extension/module/extended_status');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');

        if( ( $this->request->server['REQUEST_METHOD'] == 'POST' ) && $this->validate() ) {
            $this->model_setting_setting->editSetting('extended_status', $this->request->post);
            $this->session->data['success'] = $this->language->get('text_success');

            $this->response->redirect($this->url->link('extension/module/extended_status', 'token=' . $this->session->data['token'] . '&type=module', true));
        }

        $data['heading_title'] = $this->language->get('heading_title');

        $data['text_edit'] = $this->language->get('text_edit');
        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_disabled'] = $this->language->get('text_disabled');

        $data['help_success'] = $this->language->get('help_success');
        $data['help_error'] = $this->language->get('help_error');
        $data['help_warning'] = $this->language->get('help_warning');

        $data['entry_name'] = $this->language->get('entry_name');
        $data['entry_time'] = $this->language->get('entry_time');
        $data['entry_month'] = $this->language->get('entry_month');

        $data['entry_status'] = $this->language->get('entry_status');

        $data['button_save'] = $this->language->get('button_save');
        $data['button_cancel'] = $this->language->get('button_cancel');

        if( isset($this->error['warning']) ) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true),
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_extension'),
            'href' => $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true),
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('extension/module/extended_status', 'token=' . $this->session->data['token'], true),
        );

        $data['action'] = $this->url->link('extension/module/extended_status', 'token=' . $this->session->data['token'], true);

        $data['cancel'] = $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true);

        if( isset($this->request->post['extended_status_name']) ) {
            $data['extended_status_name'] = $this->request->post['extended_status_name'];
        } else {
            $data['extended_status_name'] = $this->config->get('extended_status_name');
        }

        $this->load->model('localisation/stock_status');

        $stock_statuses = $this->model_localisation_stock_status->getStockStatuses();

        if( isset($this->request->post['extended_status_custom']) ) {
            $config_statuses = $this->request->post['extended_status_custom'];
        } elseif( $this->config->get('extended_status_custom') ) {
            $config_statuses = $this->config->get('extended_status_custom');
        } else {
            $config_statuses = array();
        }

        $data['custom_statuses'] = array();

        foreach( $stock_statuses as $status ) {
            if( !empty($config_statuses[$status['stock_status_id']]) ) {
                $conf_status = $config_statuses[$status['stock_status_id']];
            } else {
                $conf_status = array();
            }

            $data['custom_statuses'][$status['stock_status_id']] = array(
                'original_name' => $status['name'],
                'name'          => isset($conf_status['name']) ? $conf_status['name'] : $status['name'],
                'deliveries'    => isset($conf_status['deliveries']) ? $conf_status['deliveries'] : array(),
            );
        }

        $data['current_time'] = sprintf($this->language->get('current_time'), date('H:i:s / j.n.Y'));

        if( isset($this->request->post['extended_status_time']) ) {
            $data['extended_status_time'] = $this->request->post['extended_status_time'];
        } else {
            $data['extended_status_time'] = $this->config->get('extended_status_time');
        }

        if( isset($this->request->post['extended_status_holiday']) ) {
            $extended_status_holiday = $this->request->post['extended_status_holiday'];
        } elseif( $this->config->get('extended_status_holiday') ) {
            $extended_status_holiday = $this->config->get('extended_status_holiday');
        } else {
            $extended_status_holiday = array(
                1  => '',
                2  => '',
                3  => '',
                4  => '',
                5  => '',
                6  => '',
                7  => '',
                8  => '',
                9  => '',
                10 => '',
                11 => '',
                12 => '',
            );
        }

        $data['holiday_days'] = array();

        foreach( $extended_status_holiday as $month => $holidays ) {
            $data['holiday_days'][$month] = array(
                'month_text' => $this->language->get('month_' . $month),
                'holidays'   => $holidays,
            );
        }


        if( isset($this->request->post['extended_status_status']) ) {
            $data['extended_status_status'] = $this->request->post['extended_status_status'];
        } else {
            $data['extended_status_status'] = $this->config->get('extended_status_status');
        }

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('extension/module/extended_status', $data));
    }

    protected function validate() {
        if( !$this->user->hasPermission('modify', 'extension/module/extended_status') ) {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        return !$this->error;
    }
}