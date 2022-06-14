<% if search == '' then %>
  <a href="<%= page:make_url(controller..'/index', {index = index - 1}) %>" role="button" class="outline">&lt;</a>
  <a href="<%= page:make_url(controller..'/index', {index = index + 1}) %>" role="button">&gt;</a>
<% else %>
  <a href="<%= page:make_url(controller..'/index', {index = index - 1, search = search}) %>" role="button" class="outline">&lt;</a>
  <a href="<%= page:make_url(controller..'/index', {index = index + 1, search = search}) %>" role="button">&gt;</a>
<% end %>
