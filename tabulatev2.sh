#!/bin/sh


usage() { echo "Usage: $0 "'-d "your_input_data_delimiter_character" -t "My Title" -h "My Header"' 1>&2; exit 1; }

IFS_CHAR=" "
MY_TITLE="MY_TITLE"
MY_HEADER="MY_HEADER"

while getopts "d:t:h:" inp; do
    case "${inp}" in
        d) 
            IFS_CHAR=${OPTARG};;
        t) 
            MY_TITLE=${OPTARG};;
        h) 
            MY_HEADER=${OPTARG};;                        
        *) 
            usage;;   
     esac
done


# Compose the html file with the Header, Body ( Data ) and Footer

echo '<!DOCTYPE html>'
echo '<html>'
echo '<head>
<meta name="viewport" content="width=device-width, initial-scale=1" charset="ISO-8859-1">'
echo '<title>'$MY_TITLE'</title>'
echo '<style type="text/css">
      <!-- TD{font-family: Tahoma; font-size: 10pt;border: 3px solid black; border-style: double; text-align:center; }  TH{font-family: Tahoma; font-size: 12pt;border: 3px solid black; border-style: double; text-align:center; } --->
    </style>'

#Below script will filter as per search input
echo '<script>
function myFunction(){
  // Declare variables 
  var input, filter, table, tr, td, i;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("myTable");
  tr = table.getElementsByTagName("tr");

  // Loop through all table rows, and hide those who do not match the search query
  for (i = 1; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td") ; 
    for(j=0 ; j<td.length ; j++)
    {
      var tdata = td[j] ;
      if (tdata) {
        if (tdata.innerHTML.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
          break ; 
        } else {
          tr[i].style.display = "none";
        }
      } 
    }
  }
}
</script>'
echo '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>'
echo '<link
      rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"
    />'
echo '<style type="text/css">
      .add_red {
        background-color: red;
      }

      .add_orange {
        background-color: orange;
      }

      .add_yellow {
        background-color: yellow;
      }

      .add_green {
        background-color: green;
      }

	#myTable{
	margin-left: auto;
        margin-right: auto;
        width: 80%;
	}

	</style>'

echo        

       echo '</head>'

       echo '<body>'

echo '<table width="100%" border="9" bordercolor="purple">
      <tr>
        <td bgcolor="white" valign="top">
          <br />
          <p style="text-align: center; font-size: 16pt; font-family: Tahoma">
            <b
              >&nbsp A T & T - NetBackup Diskpool(PureDisk &StoreOnce) status Report
            </b>
          </p>
          <br />
          <input
            type="text"
            id="myInput"
            onkeyup="myFunction()"
            placeholder="Search in all Fields...."
            title="Type in a Search String"
            autofocus="autofocus"
          />'
       echo '<table width="100%" border="1" id="myTable">'


# the following 10 lines are commented by way of the first and last line characters. Please remove the first and last lines to get fixed-width of columns. Also, adjust the number of col lines and their values, to suit yur input data.
<< --MULTILINE-COMMENT--
       echo '<col width="164" />
             <col width="236" />
             <col width="130" />
             <col width="191" />
             <col width="115" />
             <col width="87" />
             <col width="145" />             
             <col width="126" />'
--MULTILINE-COMMENT--

# the following 13 lines are commented by way of the first and last line characters. Please remove the first and last lines to get customized table header lines. Also, adjust the number of header lines and header data, to suit your input.
<< --MULTILINE-COMMENT--
       echo '<tr class="header">'
       echo '<th>Title</th>'
       echo '<th>Description</th>'
       echo '<th>Version</th>'
       # echo '<th>Author</th>'
       echo '<th>Original-site</th>'
       echo '<th>License</th>'
       echo '<th>Size</th>'
       echo '<th>Extension_by</th>'
       echo '<th>Tags</th>'
       echo '</tr>'
--MULTILINE-COMMENT--

# Read the standard input data file contents into an Array, Check for URLs to Create Hyperlinks and
# Also Substitute html sensitive characters with proper syntax

cat - | sed '/^$/d' | awk -F "$IFS_CHAR" -v header=1 'BEGIN{OFS="\t";}
{
        # gsub(/</, "\\&lt;")
        # gsub(/>/, "\\&gt;")
        # gsub(/&/, "\\&gt;")
        print "\t<tr>"
        for(f = 1; f <=NF; f++)  {
                if(NR == 1 && header) {
                        printf "\t\t<th>%s</th>\n", $f
                }
                else printf "\t\t<td>%s</td>\n", $f
        }
        print "\t</tr>"
}



END {
       print "</td></tr></table></table></body>"
}'


# Un-hash the below line, if you need a compressed gzip file also, for very large files.
# gzip -9 --verbose < $html > $html.gz

