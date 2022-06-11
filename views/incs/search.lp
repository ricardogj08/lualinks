<form method="post" action="<%= page:make_url(controller..'/index', {search = search}) %>">
  <input type="search" name="search" placeholder="Search" value="<%= search %>" maxlength="<%= maxlength %>" autofocus>
</form>
