<?lua local form = require "sailor.form" ?>
<h2>Update tag</h2>
<?lua if saved == false then ?>
There was an error while saving.
<?lua end ?>
<form method="post">
  <div class="form-group">
    <label>id:</label>
    <%= form.text(tag,'id', 'class="form-control" placeholder="id"') %>
  </div>
  <div class="form-group">
    <label>name:</label>
    <%= form.text(tag,'name', 'class="form-control" placeholder="name"') %>
  </div>
  <div class="form-group">
    <label>user_id:</label>
    <%= form.text(tag,'user_id', 'class="form-control" placeholder="user_id"') %>
  </div>
  <input type="submit" class="btn btn-primary"/>
</form>
<br/>
<a href="<%= page:make_url('tag/index') %>"><- Back to View All</a>
