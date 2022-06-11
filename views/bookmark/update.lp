<article>
  <hgroup>
    <h1>Update bookmark</h1>
    <h2>Update bookmark information</h2>
  </hgroup>

  <% if saved == false then %>
    <p><small>The bookmark data was not changed.</small></p>
  <% end %>

  <% page:include('/views/bookmark/form', {bookmark = bookmark, tag = tag}) %>
</article>
