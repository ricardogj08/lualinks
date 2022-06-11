<article>
  <hgroup>
    <h1>Add bookmark</h1>
    <h2>Add a new bookmark</h2>
  </hgroup>

  <% if saved == false then %>
    <p><small>There was an error while saving.</small></p>
  <% end %>

  <% page:include('/views/bookmark/form', {bookmark = bookmark, tag = tag}) %>
</article>
