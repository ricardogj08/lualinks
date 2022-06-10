<% local date = require('date') %>
<section>
  <hgroup>
    <h1><%= tag.name %></h1>
    <h2>Bookmarks</h2>
  </hgroup>

  <p>
    <a href="<%= page:make_url('tag/index') %>" role="button">&lt; Back to tags</a>
    <a href="<%= page:make_url('tag/update', {id = tag.id}) %>" role="button" class="secondary">Update</a>
  </p>

  <div>
    <% for _,b in ipairs(tag.bookmarks) do %>
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
          <a href="<%= page:make_url('bookmark/delete', {id = b.id}) %>" class="contrast"><small>Delete</small></a>
          <a href="<%= page:make_url('bookmark/update', {id = b.id}) %>" class="secondary"><small>Update</small></a>
        </div>
      </div>
    <% end %>
  </div>
  <hr>
</section>
