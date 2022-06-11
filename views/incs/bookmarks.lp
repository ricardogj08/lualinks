<% local date = require('date') %>
<div>
  <% for _,b in ipairs(bookmarks) do %>
  <div>
    <hr>
    <div>
      <a href="<%= b.url %>" target="_blank">&#128204; <strong><%= b.title %></strong></a>
    </div>
    <div>
      <a href="<%= b.url %>" target="_blank" class="secondary"><small><%= b.url %></small></a>
    </div>
    <div><%= b.description or '' %></div>
    <div>
      <% for _,t in ipairs(b.tags) do %>
      <a href="<%= page:make_url('tag/view', {id = t.id}) %>">#<%= t.name %></a>
      <% end %>
    </div>
    <div>
      <small>&#128197; <%= date(b.updated_at):fmt("%d %b %Y") %></small> &vert;
      <% page:include('/views/incs/modal', {title = 'Delete', class = 'contrast', msg = 'Are you sure you want to delete this bookmark?', route = page:make_url('bookmark/delete', {id = b.id})}) %>
      <a href="<%= page:make_url('bookmark/update', {id = b.id}) %>" class="secondary"><small>Update</small></a>
    </div>
  </div>
  <% end %>
</div>
<hr>
