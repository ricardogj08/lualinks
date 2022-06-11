<section>
  <hgroup>
    <h1>Tags</h1>
    <h2>View all tags</h2>
  </hgroup>

  <% page:include('/views/incs/search', {controller = 'tag', search = search, maxlength = 64}) %>

  <p>
    <% for _,v in ipairs(tags) do %>
    <a href="<%= page:make_url('tag/view', {id = v.id}) %>">#<%= v.name %></a>
    <% end %>
  </p>
</section>
