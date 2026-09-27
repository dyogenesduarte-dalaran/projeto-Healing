CREATE TABLE tentativa_pagamento (
                                     id_tentativa_pagamento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                     id_pagamento INTEGER NOT NULL,
                                     data_hora_tentativa TIMESTAMP NOT NULL,
                                     resultado_tentativa VARCHAR(30) NOT NULL,
                                     motivo_recusa VARCHAR(255),

                                     FOREIGN KEY (id_pagamento)
                                         REFERENCES pagamento(id_pagamento)
);