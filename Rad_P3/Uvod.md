---
title: "Modeliranje evolucije populacija gujavica"
author: "Vaše Ime"
date: "\`r Sys.Date()\`"
output:
  pdf_document:
    keep_tex: true
header-includes:
  - \usepackage{amsmath}
  - \usepackage{amssymb}
  - \usepackage{graphicx}
---

# Uvod

Evolucija i dinamika populacija temeljni su fenomeni u biologiji, ekologiji i evolucijskoj teoriji. Gujavice (*Oligochaeta*) igraju ključnu ulogu u ekosustavima, posebno u procesima poput razgradnje organske tvari, stvaranja humusa i povećanja plodnosti tla. Unatoč njihovoj važnosti, detaljno razumijevanje dinamike populacije gujavica pod utjecajem evolucijskih procesa, poput mutacija i prirodne selekcije, još uvijek je ograničeno. U ovom radu, prilagođujemo stohastički model evolucije podvrsta (Roy & Tanemura, 2019) kako bismo istražili dinamiku populacije gujavica i njihovu prilagodbu specifičnim uvjetima okoliša.

## Matematički okvir modela

Model se temelji na sljedećim osnovnim procesima:

1. **Rođenje**: Nova jedinka može biti mutant ili može naslijediti fitness od postojeće populacije.
2. **Mutacija**: Nova jedinka dobiva nasumičnu vrijednost fitnessa u intervalu [0, 1].
3. **Smrt**: Jedinke s najnižim fitnessom imaju najvišu vjerojatnost smrtnosti.

### Formalni opis modela

Neka je populacija u trenutku \(n\) opisana skupom:
\[
X_n = \{(k_i, f_i) : k_i \geq 1, f_i \in [0, 1], i = 1, \dots, l \},
\]
gdje je \(k_i\) veličina populacije na fitness razini \(f_i\), a \(l\) ukupan broj razina fitnessa u populaciji.

Ukupna populacija u trenutku \(n\) dana je:
\[
N_n = \sum_{i=1}^l k_i.
\]

#### Proces rođenja
S vjerojatnošću \(p\) dolazi do rođenja nove jedinke. Nova jedinka može:
1. Biti mutant s fitness parametrom \(f \sim U(0,1)\) (uniformna distribucija).
2. Naslijediti fitness \(f_i\) od postojeće populacije s vjerojatnošću proporcionalnom veličini populacije na toj razini fitnessa:
\[
P(f = f_i) = \frac{k_i}{N_n}, \quad i = 1, \dots, l.
\]

#### Proces smrti
S vjerojatnošću \(1-p\) dolazi do smrti jedinke. Jedinka na fitness razini s najmanjim \(f\) ima najveću vjerojatnost za smrtnost. Uklanja se jedna jedinka iz populacije s najmanjim fitnessom.

#### Fazni prijelaz
Model pokazuje fazni prijelaz definiran kritičnom vrijednošću fitnessa \(f_c = \frac{1-p}{pr}\), gdje:
- Ako \(f < f_c\), populacija na toj razini fitnessa povremeno izumire.
- Ako \(f > f_c\), populacija raste i koncentrira se u intervalu
