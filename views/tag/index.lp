<section>
  <hgroup>
    <h1>Tags</h1>
    <h2>View all tags</h2>
  </hgroup>

  <form method="post" action="<%= page:make_url('tag/index', {search = search}) %>">
    <input type="search" name="search" placeholder="Search" value="<%= search %>" maxlength="64" autofocus>
  </form>

  <p>
    <% for _,v in ipairs(tags) do %>
    <a href="<%= page:make_url('tag/view', {id = v.id}) %>">#<%= v.name %></a>
    <% end %>
  </p>
</section>
