#@tool
extends Node2D
class_name WorldMap
var country_codes = {
	'AF' : 'Afghanistan',
	'AX' : 'Aland Islands',
	'AL' : 'Albania',
	'DZ' : 'Algeria',
	'AS' : 'American Samoa',
	'AD' : 'Andorra',
	'AO' : 'Angola',
	'AI' : 'Anguilla',
	'AQ' : 'Antarctica',
	'AG' : 'Antigua And Barbuda',
	'AR' : 'Argentina',
	'AM' : 'Armenia',
	'AW' : 'Aruba',
	'AU' : 'Australia',
	'AT' : 'Austria',
	'AZ' : 'Azerbaijan',
	'BS' : 'Bahamas',
	'BH' : 'Bahrain',
	'BD' : 'Bangladesh',
	'BB' : 'Barbados',
	'BY' : 'Belarus',
	'BE' : 'Belgium',
	'BZ' : 'Belize',
	'BJ' : 'Benin',
	'BM' : 'Bermuda',
	'BT' : 'Bhutan',
	'BO' : 'Bolivia',
	'BA' : 'Bosnia And Herzegovina',
	'BW' : 'Botswana',
	'BV' : 'Bouvet Island',
	'BR' : 'Brazil',
	'IO' : 'British Indian Ocean Territory',
	'BN' : 'Brunei Darussalam',
	'BG' : 'Bulgaria',
	'BF' : 'Burkina Faso',
	'BI' : 'Burundi',
	'KH' : 'Cambodia',
	'CM' : 'Cameroon',
	'CA' : 'Canada',
	'CV' : 'Cape Verde',
	'KY' : 'Cayman Islands',
	'CF' : 'Central African Republic',
	'TD' : 'Chad',
	'CL' : 'Chile',
	'CN' : 'China',
	'CX' : 'Christmas Island',
	'CC' : 'Cocos (Keeling) Islands',
	'CO' : 'Colombia',
	'KM' : 'Comoros',
	'CG' : 'Congo',
	'CD' : 'Congo, Democratic Republic',
	'CK' : 'Cook Islands',
	'CR' : 'Costa Rica',
	'CI' : 'Cote D\'Ivoire',
	'HR' : 'Croatia',
	'CU' : 'Cuba',
	'CY' : 'Cyprus',
	'CZ' : 'Czech Republic',
	'DK' : 'Denmark',
	'DJ' : 'Djibouti',
	'DM' : 'Dominica',
	'DO' : 'Dominican Republic',
	'EC' : 'Ecuador',
	'EG' : 'Egypt',
	'SV' : 'El Salvador',
	'GQ' : 'Equatorial Guinea',
	'ER' : 'Eritrea',
	'EE' : 'Estonia',
	'ET' : 'Ethiopia',
	'FK' : 'Falkland Islands (Malvinas)',
	'FO' : 'Faroe Islands',
	'FJ' : 'Fiji',
	'FI' : 'Finland',
	'FR' : 'France',
	'FG' : 'French Guiana',
	'GF' : 'French Guiana',
	'PF' : 'French Polynesia',
	'TF' : 'French Southern Territories',
	'GA' : 'Gabon',
	'GM' : 'Gambia',
	'GE' : 'Georgia',
	'DE' : 'Germany',
	'GH' : 'Ghana',
	'GI' : 'Gibraltar',
	'GR' : 'Greece',
	'GL' : 'Greenland',
	'GD' : 'Grenada',
	'GP' : 'Guadeloupe',
	'GU' : 'Guam',
	'GT' : 'Guatemala',
	'GG' : 'Guernsey',
	'GN' : 'Guinea',
	'GW' : 'Guinea-Bissau',
	'GY' : 'Guyana',
	'HT' : 'Haiti',
	'HM' : 'Heard Island & Mcdonald Islands',
	'VA' : 'Holy See (Vatican City State)',
	'HN' : 'Honduras',
	'HK' : 'Hong Kong',
	'HU' : 'Hungary',
	'IS' : 'Iceland',
	'IN' : 'India',
	'ID' : 'Indonesia',
	'IR' : 'Iran, Islamic Republic Of',
	'IQ' : 'Iraq',
	'IE' : 'Ireland',
	'IM' : 'Isle Of Man',
	'IL' : 'Israel',
	'IT' : 'Italy',
	'JM' : 'Jamaica',
	'JP' : 'Japan',
	'JE' : 'Jersey',
	'JO' : 'Jordan',
	'KZ' : 'Kazakhstan',
	'KE' : 'Kenya',
	'KI' : 'Kiribati',
	'KR' : 'South Korea',
	'KP' : 'North Korea',
	'KW' : 'Kuwait',
	'KG' : 'Kyrgyzstan',
	'LA' : 'Lao People\'s Democratic Republic',
	'LV' : 'Latvia',
	'LB' : 'Lebanon',
	'LS' : 'Lesotho',
	'LR' : 'Liberia',
	'LY' : 'Libyan Arab Jamahiriya',
	'LI' : 'Liechtenstein',
	'LT' : 'Lithuania',
	'LU' : 'Luxembourg',
	'MO' : 'Macao',
	'MK' : 'Macedonia',
	'MG' : 'Madagascar',
	'MW' : 'Malawi',
	'MY' : 'Malaysia',
	'MV' : 'Maldives',
	'ML' : 'Mali',
	'MT' : 'Malta',
	'MH' : 'Marshall Islands',
	'MQ' : 'Martinique',
	'MR' : 'Mauritania',
	'MU' : 'Mauritius',
	'YT' : 'Mayotte',
	'MX' : 'Mexico',
	'FM' : 'Micronesia, Federated States Of',
	'MD' : 'Moldova',
	'MC' : 'Monaco',
	'MN' : 'Mongolia',
	'ME' : 'Montenegro',
	'MS' : 'Montserrat',
	'MA' : 'Morocco',
	'MZ' : 'Mozambique',
	'MM' : 'Myanmar',
	'NA' : 'Namibia',
	'NR' : 'Nauru',
	'NP' : 'Nepal',
	'NL' : 'Netherlands',
	'AN' : 'Netherlands Antilles',
	'NC' : 'New Caledonia',
	'NZ' : 'New Zealand',
	'NI' : 'Nicaragua',
	'NE' : 'Niger',
	'NG' : 'Nigeria',
	'NU' : 'Niue',
	'NF' : 'Norfolk Island',
	'MP' : 'Northern Mariana Islands',
	'NO' : 'Norway',
	'OM' : 'Oman',
	'PK' : 'Pakistan',
	'PW' : 'Palau',
	'PS' : 'Palestinian Territory, Occupied',
	'PA' : 'Panama',
	'PG' : 'Papua New Guinea',
	'PY' : 'Paraguay',
	'PE' : 'Peru',
	'PH' : 'Philippines',
	'PN' : 'Pitcairn',
	'PL' : 'Poland',
	'PT' : 'Portugal',
	'PR' : 'Puerto Rico',
	'QA' : 'Qatar',
	'RE' : 'Reunion',
	'RO' : 'Romania',
	'RU' : 'Russian Federation',
	'RW' : 'Rwanda',
	'BL' : 'Saint Barthelemy',
	'SH' : 'Saint Helena',
	'KN' : 'Saint Kitts And Nevis',
	'LC' : 'Saint Lucia',
	'MF' : 'Saint Martin',
	'PM' : 'Saint Pierre And Miquelon',
	'VC' : 'Saint Vincent And Grenadines',
	'WS' : 'Samoa',
	'SM' : 'San Marino',
	'ST' : 'Sao Tome And Principe',
	'SA' : 'Saudi Arabia',
	'SN' : 'Senegal',
	'RS' : 'Serbia',
	'SC' : 'Seychelles',
	'SL' : 'Sierra Leone',
	'SG' : 'Singapore',
	'SK' : 'Slovakia',
	'SI' : 'Slovenia',
	'SB' : 'Solomon Islands',
	'SO' : 'Somalia',
	'ZA' : 'South Africa',
	'GS' : 'South Georgia And Sandwich Isl.',
	'ES' : 'Spain',
	'LK' : 'Sri Lanka',
	'SD' : 'Sudan',
	'SS' : 'South Sudan',
	'SR' : 'Suriname',
	'SJ' : 'Svalbard And Jan Mayen',
	'SZ' : 'Swaziland',
	'SE' : 'Sweden',
	'CH' : 'Switzerland',
	'SY' : 'Syrian Arab Republic',
	'TW' : 'Taiwan',
	'TJ' : 'Tajikistan',
	'TZ' : 'Tanzania',
	'TH' : 'Thailand',
	'TL' : 'Timor-Leste',
	'TG' : 'Togo',
	'TK' : 'Tokelau',
	'TO' : 'Tonga',
	'TT' : 'Trinidad And Tobago',
	'TN' : 'Tunisia',
	'TR' : 'Turkey',
	'TM' : 'Turkmenistan',
	'TC' : 'Turks And Caicos Islands',
	'TV' : 'Tuvalu',
	'UG' : 'Uganda',
	'UA' : 'Ukraine',
	'AE' : 'United Arab Emirates',
	'GB' : 'United Kingdom',
	'US' : 'United States',
	'UM' : 'United States Outlying Islands',
	'UY' : 'Uruguay',
	'UZ' : 'Uzbekistan',
	'VU' : 'Vanuatu',
	'VE' : 'Venezuela',
	'VN' : 'Viet Nam',
	'VG' : 'Virgin Islands, British',
	'VI' : 'Virgin Islands, U.S.',
	'WF' : 'Wallis And Futuna',
	'EH' : 'Western Sahara',
	'YE' : 'Yemen',
	'ZM' : 'Zambia',
	'ZW' : 'Zimbabwe',
}

signal hovered_region_changed(region, country_name : String)
signal map_setup_complete()
var active_country
var all_shapes : Array[ScalableVectorShape2D] = []
var all_countries : Dictionary = {}
@export var navigation_mesh : NavigationRegion2D

func _ready():
	var level_navigation_map = get_world_2d().get_navigation_map()
	NavigationServer2D.map_set_edge_connection_margin(level_navigation_map, 5)
	all_shapes = get_child_SBS2D()
	for shape in all_shapes:
		var name = get_country_name(shape)
		if all_countries.has(name) == false:
			all_countries[name] = [shape]
		else:
			all_countries[name].append(shape)
	
	for country in all_countries.values():
		var rand_color = Color(randf_range(0.65,0.75),randf_range(0.65,0.75),randf_range(0.45,0.55))
		for region : ScalableVectorShape2D in country:
			region.collision_object.input_pickable = true
			region.collision_object.input_event.connect(_on_static_body_2d_input_event)
			region.collision_object.mouse_entered.connect(_update_selected_country.bind(true, region, get_country_name(country[0])))
			region.collision_object.mouse_exited.connect(_update_selected_country.bind(false, region, get_country_name(country[0])))
			region.polygon.color = rand_color
			
	for region in get_child_SBS2D(self):
		region.set_process_internal(true)
		print(region)
		if region.navigation_region == null:
			print("Generating Mesh for ", region)
			var new_nav_mesh = NavigationPolygon.new()
			new_nav_mesh.add_outline(region.polygon.polygon)
			new_nav_mesh.agent_radius = .5
			new_nav_mesh.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
			
			var new_nav_region2d = NavigationRegion2D.new()
			new_nav_region2d.navigation_polygon = new_nav_mesh
			new_nav_region2d.navigation_layers = 2
			new_nav_region2d.enter_cost = 10
			new_nav_region2d.travel_cost = 2
			new_nav_region2d.bake_navigation_polygon()
			region.add_child(new_nav_region2d)
	map_setup_complete.emit()
		#print(get_country_name(country[0])," ",country.size())
	
		

func get_child_SBS2D(target = self) -> Array[ScalableVectorShape2D]:
	var valid_shapes : Array[ScalableVectorShape2D] = []
	for ele in target.get_children():
		if ele is ScalableVectorShape2D:
			valid_shapes.append(ele)
	return valid_shapes

func get_country_name(country_reference : ScalableVectorShape2D):
	var iso_code = country_reference.name.substr(0,2).to_upper()
	var country_name = country_codes[iso_code]
	return country_name

#TODO: Make this work via a shader
func _update_selected_country(entering : bool, region_col, country):
	if entering:
		print(country, " - " , region_col)
		hovered_region_changed.emit(region_col, country)
		for region in all_countries[country]:
			region.polygon.color = Color.WHITE
	else:
		hovered_region_changed.emit(null, null)
		var rand_color = Color(randf_range(0.65,0.75),randf_range(0.65,0.75),randf_range(0.45,0.55))
		for region in all_countries[country]:
			region.polygon.color = rand_color


func _on_static_body_2d_input_event(viewport, event : InputEvent, shape_idx):
	#print(event.global_position)
	var test = event
	pass # Replace with function body.

#@export_tool_button("Destroy Navigation Meshes", "Callable") var naviagtion_mesh_button = destroy_navigation_mesh
#
#func destroy_navigation_mesh():
	#print("Attempting Destruction")
	#for region in get_child_SBS2D(self):
		#for child in region.find_children("*","NavigationRegion2D"):
			#print("Deleting - ", region)
			#child.queue_free()
			#
#@export_tool_button("Generate Navigation Meshes", "Callable") var gen_naviagtion_mesh_button = generate_navigation_mesh	
	#
#func generate_navigation_mesh():
	#print("Attempting Generation")
