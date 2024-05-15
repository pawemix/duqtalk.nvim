local M = {}

local ns = vim.api.nvim_create_namespace("duqtalk")

local state = {
	---@type number?
	service_job_id = nil,
	---@alias row number
	---@alias extmark_id number
	---@type { [row]: extmark_id }
	virt_texts = {},
}

local function draw_virt_text(row, message, highlighting)
	state.prompt_line_row = row
	local extmark_id = vim.api.nvim_buf_set_extmark(0, ns, row - 1, -1, {
		id = state.virt_texts[row],
		virt_text = {
			{ message, highlighting },
		},
	})
	state.virt_texts[row] = extmark_id
end

function M.interact()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local prompt = vim.api.nvim_get_current_line()
	local prompt_json = vim.json.encode(prompt)
	local response_json_lines = { "" }
	if not state.service_job_id then
		state.service_job_id = vim.fn.jobstart({ "duqtalk", "--json" }, {
			rpc = false,
			on_stdout = function(_, data, _)
				-- TODO: if it's an EOF, react accordingly
				-- if #data == 1 and data[1] == "" then end

				-- otherwise, append to aggregator:
				-- complete the previous line:
				local rjl_len = #response_json_lines
				response_json_lines[rjl_len] = response_json_lines[rjl_len]
					.. table.remove(data, 1)
				-- append all remaining provided lines:
				for _, line in ipairs(data) do
					table.insert(response_json_lines, line)
				end
				-- if there is at least one finished line
				local response_json = table.remove(response_json_lines, 1)
				if response_json == nil or response_json == "" then return end
				local response_text = vim.json.decode(response_json)
				assert(response_text)
				local response_lines = vim.split(response_text, "\n")
				-- FIXME: row may not persist here - handle that state better
				-- vim.api.nvim_buf_del_extmark(0, ns, state.virt_texts[row])
				-- state.virt_texts[row] = nil
				for _, row_ in pairs(state.virt_texts) do
					vim.api.nvim_buf_del_extmark(0, ns, row_)
				end
				vim.api.nvim_buf_set_lines(0, row, row, false, response_lines)
			end,
		})
	end

	vim.api.nvim_chan_send(state.service_job_id, prompt_json .. "\n")
	draw_virt_text(row, "Loading...", "Comment")
	-- vim.fn.chanclose(state.service_job_id, "stdin")
	-- state.service_job_id = nil

	-- close the job once the buffer is unloaded
	vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
		callback = function()
			if state.service_job_id then
				vim.fn.chanclose(state.service_job_id, "stdin")
				vim.fn.jobstop(state.service_job_id)
			end
			return true
		end,
	})
end

return M
