<div class="accordion mb-4" id="productPanels">
    <div class="card">
        <div class="card-header">
            <h3 class="accordion-heading">
                <a href="#shippingOptions" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="shippingOptions" class=""><i class="czi-delivery text-muted lead align-middle mt-n1 mr-2"></i>
                    <?php if( $module_name ) {
                        echo $module_name;
                    } else {
                        echo $stock;
                    } ?>
                    <span class="accordion-indicator">
                        <i data-feather="chevron-up"></i></span>
                </a></h3>
        </div>
        <div class="collapse show" id="shippingOptions" data-parent="#productPanels" style="">
            <div class="card-body font-size-sm">
                <?php foreach( $deliveries as $index => $delivery ) { ?>
                    <div class="d-flex justify-content-between <?php echo( $index == 0 ? 'border-bottom pb-2' : 'border-bottom py-2' ); ?>">
                        <div>
                            <div class="font-weight-semibold text-dark"><?php echo $delivery['title']; ?></div>
                            <div class="font-size-sm text-muted"><?php echo $delivery['date']; ?></div>
                        </div>
                        <?php if( $delivery['cost'] ) { ?>
                            <div><?php echo $delivery['cost']; ?></div>
                        <?php } ?>
                    </div>
                <?php } ?>
            </div>
        </div>
    </div>
</div>