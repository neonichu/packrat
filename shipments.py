#!/usr/bin/env python

from BeautifulSoup import BeautifulSoup as soup

html = soup(file('logged_in.html'))
for div in html('div', {'id': 'shipmentList'}):
    for tr in div('tr')[3:]:
        data = tr('td')[:3]
        print 'Identcode: %s' % data[0].next
        break

# Format: Identcode, Ankunft, Abholung
#
#<tr><td class="tabledata">147016382709</td>
#<td class="tabledata">27.04.2011 10:30:45</td>
#<td class="tabledata">27.04.2011 17:29:49</td>
#<td class="tabledata"></td>
#<td class="tabledata"></td></tr>
