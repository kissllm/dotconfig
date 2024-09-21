
return {
	"vimwiki/vimwiki",
	dependencies = {
		{'Konfekt/FastFold'},
	},
	-- cond  = false,
	cond  = true,
	event = "VeryLazy",
	lazy  = true,
	-- https://www.reddit.com/r/neovim/comments/ksyydr/how_to_convert_vimwiki_list_variable_to_lua/
	config = function()

		local wiki = {}

		wiki.path = '~/.wiki/'
		wiki.syntax = 'markdown'
		-- wiki.ext = '.md'
		wiki.ext = '.wiki'

		local wiki_personal = {}
		wiki_personal.path = '~/.vimwiki_personal/'
		wiki_personal.syntax = 'markdown'
		-- wiki_personal.ext = '.md'
		wiki_personal.ext = '.wiki'

		vim.g.vimwiki_list = {
			wiki, wiki_personal
			-- {
			--  path = '~/.wiki/',
			--  syntax = 'markdown',
			--  ext = '.md',
			-- },
			-- {
			--  path = '~/.vimwiki_personal/',
			--  syntax = 'markdown',
			--  ext = '.md',
			-- },
		}
		--
		-- https://stackoverflow.com/questions/65549814/setting-vimwiki-list-in-a-lua-init-file
		vim.g.vimwiki_global_ext = 0
		-- vim.g.vimwiki_ext2syntax = {['.md'] = 'markdown', ['.markdown'] = 'markdown', ['.mdown'] = 'markdown'}
		vim.g.vimwiki_ext2syntax = {}
		vim.cmd([[
		augroup vimwiki_markdown | au!
			autocmd BufEnter,BufRead,BufNewFile *.md set filetype=markdown
			" au BufEnter *.md set filetype=markdown
		augroup END

		" let g:vimwiki_markdown_link_ext = 1
		let g:vimwiki_markdown_link_ext = 0


		" https://www.reddit.com/r/vim/comments/9riu4c/using_vimwiki_with_markdown/
		" https://github.com/vimwiki/vimwiki/issues/345
		let g:vimwiki_global_ext = 0

		let wiki = {}
		let wiki.path = '~/.wiki/'
		let wiki.syntax = 'markdown'
		" let wiki.ext = '.md'
		let wiki.ext = '.wiki'

		let wiki_personal = {}
		let wiki_personal.path = '~/.vimwiki_personal/'
		let wiki_personal.syntax = 'markdown'
		" let wiki_personal.ext = '.md'
		let wiki_personal.ext = '.wiki'

		" https://www.reddit.com/r/vim/comments/i2v6o5/turn_off_markdown_support_in_vimwiki/
		" let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'vimwiki', 'ext': '.wiki'}]
		let g:vimwiki_global_ext = 0
		let g:vimwiki_list = [wiki, wiki_personal]
		" let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
		" https://github.com/vimwiki/vimwiki/issues/969
		" https://superuser.com/questions/495889/have-vimwiki-set-filetype-only-within-wikihome
		let g:vimwiki_ext2syntax = {}
		" Disable <Enter> create link behavior
		" https://github.com/vimwiki/vimwiki/issues/1088
		" let g:vimwiki_key_mappings = { 'all_maps': 0, }
		]])
	end,
}

