locals{
    name                              = "${var.root_id}-${var.name_suffix}"
    tags                              = merge(var.tags, {
                                          controlledby = "terraform"
                                        }) 
}