<% local date = require('date') %>
<section>
  <hgroup>
    <h1><%= user.username %></h1>
    <h2>View user account information</h2>
  </hgroup>

  <p>
    <a href="<%= page:make_url('user/index') %>" role="button">&lt; Back to users</a>
  </p>

  <table>
    <tbody>
      <tr>
        <th scope="row">ID</th>
        <td>&num;<%= user.id %></td>
      </tr>
      <tr>
        <th scope="row">Username</th>
        <td><%= user.username %></td>
      </tr>
      <tr>
        <th scope="row">Rol</th>
        <td><%= user.role.description %></td>
      </tr>
      <tr>
        <th scope="row">Created at</th>
        <td><%= date(user.created_at):fmt("${asctime}") %></td>
      </tr>
      <tr>
        <th scope="row">Updated at</th>
        <td><%= date(user.updated_at):fmt("${asctime}") %></td>
      </tr>
    </tbody>
  </table>

  <p>
    <!-- Button to trigger the modal -->
    <a href="#" role="button" class="contrast" data-target="modal" onClick="toggleModal(event)"><small>Delete</small></a>
    <a href="<%= page:make_url('user/update', {id = user.id}) %>" role="button" class="secondary">Update</a>
    <!-- Modal -->
    <dialog id="modal">
      <article>
        <a href="#close" aria-label="Close" class="close" data-target="modal" onClick="toggleModal(event)"></a>
        <h3>Confirm your action!</h3>
        <p>Are you sure you want to delete this user?</p>
        <footer>
          <a href="<%= page:make_url('user/delete', {id = user.id}) %>" role="button">Confirm</a>
          <a href="#cancel" role="button" class="secondary" data-target="modal" onClick="toggleModal(event)">Cancel</a>
        </footer>
      </article>
    </dialog>
  </p>
</section>
