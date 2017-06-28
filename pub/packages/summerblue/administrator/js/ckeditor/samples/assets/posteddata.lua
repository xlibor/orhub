?>
<!DOCTYPE html>
<?php 

Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.md or http://ckeditor.com/license

?>
<html>
<head>
	<meta charset="utf-8">
	<title>Sample &mdash; CKEditor</title>
	<link rel="stylesheet" href="sample.css">
</head>
<body>
	<h1 class="samples">
		CKEditor &mdash; Posted Data
	</h1>
	<table border="1" cellspacing="0" id="outputSample">
		<colgroup><col width="120"></colgroup>
		<thead>
			<tr>
				<th>Field&nbsp;Name</th>
				<th>Value</th>
			</tr>
		</thead>
<?php 
if not lf.isEmpty(_POST) then
    for key, value in pairs(_POST) do
        if not lf.isStr(value) and not lf.isNum(value) or not lf.isStr(key) then
            continue
        end
        if get_magic_quotes_gpc() then
            value = htmlspecialchars(stripslashes(tostring(value)))
        else 
            value = htmlspecialchars(tostring(value))
        end
        ?>
		<tr>
			<th style="vertical-align: top"><?php 
        echo(htmlspecialchars(tostring(key)))
        ?></th>
			<td><pre class="samples"><?php 
        echo(value)
        ?></pre></td>
		</tr>
	<?php 
    end
end
?>
	</table>
	<div id="footer">
		<hr>
		<p>
			CKEditor - The text editor for the Internet - <a class="samples" href="http://ckeditor.com/">http://ckeditor.com</a>
		</p>
		<p id="copy">
			Copyright &copy; 2003-2014, <a class="samples" href="http://cksource.com/">CKSource</a> - Frederico Knabben. All rights reserved.
		</p>
	</div>
</body>
</html>
<?php 