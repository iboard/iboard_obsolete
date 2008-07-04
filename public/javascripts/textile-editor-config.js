var teButtons = TextileEditor.buttons;

teButtons.push(new TextileEditorButton('ed_strong',			'bold.png',          '*',   '*',  'b', 'Bold','s'));
teButtons.push(new TextileEditorButton('ed_emphasis',		'italic.png',        '_',   '_',  'i', 'Italicize','s'));
teButtons.push(new TextileEditorButton('ed_underline',	'underline.png',     '+',   '+',  'u', 'Underline','s'));
teButtons.push(new TextileEditorButton('ed_strike',     'strikethrough.png', '-',   '-',  's', 'Strikethrough','s'));
teButtons.push(new TextileEditorButton('ed_ol',					'list_numbers.png',  ' # ', '\n', ',', 'Numbered List'));
teButtons.push(new TextileEditorButton('ed_ul',					'list_bullets.png',  ' * ', '\n', '.', 'Bulleted List'));
teButtons.push(new TextileEditorButton('ed_p',					'paragraph.png',     'p',   '\n', 'p', 'Paragraph'));
teButtons.push(new TextileEditorButton('ed_h1',					'h1.png',            'h1',  '\n', '1', 'Header 1'));
teButtons.push(new TextileEditorButton('ed_h2',					'h2.png',            'h2',  '\n', '2', 'Header 2'));
teButtons.push(new TextileEditorButton('ed_h3',					'h3.png',            'h3',  '\n', '3', 'Header 3'));
teButtons.push(new TextileEditorButton('ed_h4',					'h4.png',            'h4',  '\n', '4', 'Header 4'));
teButtons.push(new TextileEditorButton('ed_block',   		'blockquote.png',    'bq',  '\n', 'q', 'Blockquote'));
teButtons.push(new TextileEditorButton('ed_outdent', 		'outdent.png',       ')',   '\n', ']', 'Outdent'));
teButtons.push(new TextileEditorButton('ed_indent',  		'indent.png',        '(',   '\n', '[', 'Indent'));
teButtons.push(new TextileEditorButton('ed_justifyl',		'left.png',          '<',   '\n', 'l', 'Left Justify'));
teButtons.push(new TextileEditorButton('ed_justifyc',		'center.png',        '=',   '\n', 'e', 'Center Text'));
teButtons.push(new TextileEditorButton('ed_justifyr',		'right.png',         '>',   '\n', 'r', 'Right Justify'));
teButtons.push(new TextileEditorButton('ed_justify', 		'justify.png',       '<>',  '\n', 'j', 'Justify'));

teButtons.push(new TextileEditorButton('ed_image', 'add_img.png','[[image:123:320x240:embeded image]]','\n', '', 'Add Image'));
teButtons.push(new TextileEditorButton('ed_image', 'add_l_img.png','[[limage:123:embeded image]]','\n', '',        'Add Image left'));
teButtons.push(new TextileEditorButton('ed_image', 'add_r_img.png','[[rimage:123:embeded image]]','\n', '',        'Add Image right'));
teButtons.push(new TextileEditorButton('ed_image', 'add_s_img.png','[[sizedimage:123:320x240:embeded image]]','\n', '', 'Add Sized Image'));
teButtons.push(new TextileEditorButton('ed_image', 'add_ls_img.png','[[lsizedimage:123:320x240:embeded image]]','\n', '', 'Add Sized Image left'));
teButtons.push(new TextileEditorButton('ed_image', 'add_rs_img.png','[[rsizedimage:123:320x240:embeded image]]','\n', '', 'Add Sized Image right'));

teButtons.push(new TextileEditorButton('ed_image', 'add_gallery.png','[[gallerylink:123:open gallery]]','\n', '', 'Add Link To Gallery'));
teButtons.push(new TextileEditorButton('ed_image', 'add_flv.png','flv:PATH/HEX_FILE_CODE/FILENAME_WO_EXT:340:260:flv','\n', '', 'Add Link FLV-Stream'));

teButtons.push(new TextileEditorButton('ed_image', 'add_icon_link.png','[[iconlink:IMAGE_FILE_NAME.png:30:20:Title to click:HTTP_ADDRESS]]','\n', '', 'Add clickable icon'));
teButtons.push(new TextileEditorButton('ed_image', 'add_ext_url.png','[[extern:HTTP_ADDRESS:Text to click]]','\n', '', 'Add extern link'));
teButtons.push(new TextileEditorButton('ed_image', 'add_int_url.png','[[controller:CONTROLLER/PATH:goto]]','\n', '', 'Add intern (controller) link'));


// teButtons.push(new TextileEditorButton('ed_code','code','@','@','c','Code'));