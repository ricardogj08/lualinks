<!-- Button to trigger the modal -->
<a href="#" class="<%= class or 'secondary' %>" data-target="modal" onClick="toggleModal(event)"><small><%= title %></small></a>
<!-- Modal -->
<dialog id="modal">
  <article>
    <a href="#close" aria-label="Close" class="close" data-target="modal" onClick="toggleModal(event)"></a>
    <h3>Confirm your action!</h3>
    <p><%= msg %></p>
    <footer>
      <a href="<%= route %>" role="button">Confirm</a>
      <a href="#cancel" role="button" class="secondary" data-target="modal" onClick="toggleModal(event)">Cancel</a>
    </footer>
  </article>
</dialog>
