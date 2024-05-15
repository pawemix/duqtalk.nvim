# To Do

- [x] adjust `duqtalk` python service to accept JSON strings stream as input
- [x] finish `interact` function - the jobstart does not want to return responses
- [ ] fix row state management
    - response pasted always after the FIRST QUERY'S line regardless of amount of queries;
    - e.g. make a queue of queries with extmark given
- [ ] clean up job management
- [ ] interact() for Visual(-Line) Mode sends whole selection as context
- [ ] fill new buffer with mutliline question/request and save it to resolve `:w`
    - for now, wait for response and append it to the current buffer content
- [ ] pre-initialize `duqtalk` service when buffer is opened
- [ ] `:e` (at least for now) to clean the buffer -> cleans the conversation (send `null` to `duqtalk` service to clean conversation)
- [ ] persist whole chat session on the buffer
- [ ] customizable browsers & webdrivers
