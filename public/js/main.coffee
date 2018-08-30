debug = true

# Load scrobbles from Last.fm
lastFMrequest = () ->
    username = 'paul_r_schaefer'
    API_key = '0f680404e39c821cac34008cc4d803db'
    lastFM_URL = 'https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=' + username + '&api_key=' + API_key + '&limit=1&format=json'
    xhr = new XMLHttpRequest()
    music = document.getElementById('music')
    image = document.getElementById('image')

    xhr.open('GET', lastFM_URL, true)
    xhr.onreadystatechange = () ->
        if (xhr.readyState == 4 && xhr.status == 200)
            track = JSON.parse(xhr.responseText).recenttracks.track[0]
            if debug
                console.log(track)
            url = track.url
            artist = track.artist['\#text']
            album = track.album['\#text']
            song = track.name
            imgURL = track.image[3]['\#text']

            if imgURL
                image.innerHTML = '<img src="' + imgURL + '" alt="' + album + '" title="' + album + '">'
            else
                image.innerHTML = '<img src="/img/no-cover.png" alt="No Image">'
            music.innerHTML = '<p style="margin:0"><a href="' + url + '" style="color:inherit">' + song + '<br><small>' + artist + ' &mdash; ' + album + '</small></a></p>'
    xhr.send(null)

    t = setTimeout(lastFMrequest, 60000) # refresh every minute

lastFMrequest()
