<% local date = require('date') %>
<section>
  <hgroup>
    <h1>Bookmarks</h1>
    <h2>View all bookmarks</h2>
  </hgroup>

  <form method="post" action="<%= page:make_url('bookmark/index', {search = search}) %>">
    <input type="search" name="search" placeholder="Search" value="<%= search %>" autofocus>
  </form>

  <p>
    <a href="<%= page:make_url('bookmark/create') %>" role="button">&plus; Add bookmark</a>
  </p>

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
          <a href="<%= page:make_url('bookmark/delete', {id = b.id}) %>" class="contrast"><small>Delete</small></a>
          <a href="<%= page:make_url('bookmark/update', {id = b.id}) %>" class="secondary"><small>Update</small></a>
        </div>
      </div>
    <% end %>
  </div>
  <hr>

  <% if search == '' then %>
    <a href="<%= page:make_url('bookmark/index', {page = p - 1}) %>" role="button" class="contrast outline">&lt;</a>
    <a href="<%= page:make_url('bookmark/index', {page = p + 1}) %>" role="button">&gt;</a>
  <% else %>
    <a href="<%= page:make_url('bookmark/index', {page = p - 1, search = search}) %>" role="button" class="contrast outline">&lt;</a>
    <a href="<%= page:make_url('bookmark/index', {page = p + 1, search = search}) %>" role="button">&gt;</a>
  <% end %>
</section>
