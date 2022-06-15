<section>
  <hgroup>
    <h1>Bookmarks</h1>
    <h2>View all bookmarks</h2>
  </hgroup>

  <% page:include('/views/incs/search', {controller = 'bookmark', search = search, maxlength = 1024}) %>

  <p>
    <a href="<%= page:make_url('bookmark/create') %>" role="button">&plus; Add bookmark</a>
  </p>

  <% page:include('/views/incs/bookmarks', {bookmarks = bookmarks}) %>
  <% page:include('/views/incs/pagination', {controller = 'bookmark', search = search, index = index}) %>
</section>
