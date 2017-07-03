
local lx = require('lxlib')

local conf = {
    primary_keys_type = 'integer',
    normalizer = 'estGroupe.taggable.util::slug',
    displayer = 'estGroupe.taggable.util::tagName',
    untag_on_delete = true,
    delete_unused_tags = false,
    tag_model = '.app.model.tag',
    is_tagged_label_enable = false,
    tags_table_name = 'tags',
    taggables_table_name = 'taggables'
}

return conf

