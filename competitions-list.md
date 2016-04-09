---
layout: page
title: Compétitions
section:
    - speedcubing
permalink: /competitions-list/
---








<table class="planning" style="width:100%;font-size: 0.8em;">
<thead>
<tr>
<th>Competition name</th>
<th>City</th>
<th>Country</th>
<th>(Starting) Date</th>
</tr>
</thead>
<tbody id="tbody-comp">
</tbody>
</table>



<script>

var baseUrl = "http://localhost:2331";
var apiUrl = "/api/v0/competitions";
load_comps(baseUrl, apiUrl);
</script>

