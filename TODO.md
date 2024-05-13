# To Do

- [ ] `:Dchat` command to open a new buffer for chatting
- [ ] adjust `ddgai` python service to accept JSON strings stream as input
- [ ] fill new buffer with mutliline question/request and save it to resolve `:w`
    - for now, wait for response and append it to the current buffer content
- [ ] pre-initialize `ddgai` service when buffer is opened
- [ ] `:e` (at least for now) to clean the buffer -> cleans the conversation (send `null` to `ddgai` service to clean conversation)
- [ ] persist whole chat session on the buffer
