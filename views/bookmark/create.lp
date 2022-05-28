<?lua local form = require 'sailor.form' ?>
<h2>Create bookmark</h2>
<?lua if saved == false then ?>
There was an error while saving.
<?lua end ?>
<form method="post">
  <div class="form-group">
    <label>id:</label>
    <%= form.text(bookmark,'id', 'class="form-control" placeholder="id"') %>
    <span class="help-block"><%= bookmark.errors.id or '' %></span>
  </div>
  <div class="form-group">
    <label>user_id:</label>
    <%= form.text(bookmark,'user_id', 'class="form-control" placeholder="user_id"') %>
    <span class="help-block"><%= bookmark.errors.user_id or '' %></span>
  </div>
  <div class="form-group">
    <label>url:</label>
    <%= form.text(bookmark,'url', 'class="form-control" placeholder="url"') %>
    <span class="help-block"><%= bookmark.errors.url or '' %></span>
  </div>
  <div class="form-group">
    <label>title:</label>
    <%= form.text(bookmark,'title', 'class="form-control" placeholder="title"') %>
    <span class="help-block"><%= bookmark.errors.title or '' %></span>
  </div>
  <div class="form-group">
    <label>description:</label>
    <%= form.text(bookmark,'description', 'class="form-control" placeholder="description"') %>
    <span class="help-block"> <%= bookmark.errors.description or '' %></span>
  </div>
  <input type="submit" class="btn btn-primary"/>
</form>
<br/>
<a href="<%= page:make_url('bookmark/index') %>"><- Back to View All</a>
