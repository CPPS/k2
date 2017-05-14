ThinkingSphinx::Index.define :problem, with: :active_record do
	set_property min_infix_len: 2
	indexes short_name, sortable: true
	indexes name
end
