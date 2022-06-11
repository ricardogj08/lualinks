<section>
  <hgroup>
    <h1><%= tag.name %></h1>
    <h2>Tag bookmarks</h2>
  </hgroup>

  <p>
    <a href="<%= page:make_url('tag/index') %>" role="button">&lt; Back to tags</a>
    <a href="<%= page:make_url('tag/update', {id = tag.id}) %>" role="button" class="secondary">Update</a>
  </p>

  <% page:include('/views/incs/bookmarks', {bookmarks = tag.bookmarks}) %>
</section>
