<?lua local form = require 'sailor.form' ?>
<h2>Update bookmark</h2>
<?lua if saved == false then ?>
There was an error while saving.
<?lua end ?>
<form method="post">
  <div class="form-group">
    <label>id:</label>
    <%= form.text(bookmark,'id', 'class="form-control" placeholder="id"') %>
  </div>
  <div class="form-group">
    <label>user_id:</label>
    <%= form.text(bookmark,'user_id', 'class="form-control" placeholder="user_id"') %>
  </div>
  <div class="form-group">
    <label>url:</label>
    <%= form.text(bookmark,'url', 'class="form-control" placeholder="url"') %>
  </div>
  <div class="form-group">
    <label>title:</label>
    <%= form.text(bookmark,'title', 'class="form-control" placeholder="title"') %>
  </div>
  <div class="form-group">
    <label>description:</label>
    <%= form.text(bookmark,'description', 'class="form-control" placeholder="description"') %>
  </div>
  <input type="submit" class="btn btn-primary"/>
</form>
<br/>
<a href="<%= page:make_url('bookmark/index') %>"><- Back to View All</a>
