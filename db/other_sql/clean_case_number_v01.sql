-- replace crf_number with any case number field
select CASE
           WHEN (
               (crf_number)::text ~ '^([A-Za-z]{2,3})?-?[0-9]{2,4}-[0-9]{1,8}'::text
               ) THEN (
               (
                   (
                       (
                           CASE
                               WHEN ((crf_number)::text ~ '^[A-Za-z]{2,3}'::text)
                                   THEN "substring"((crf_number)::text, '^([A-Za-z]{2,3})'::text)
                               ELSE 'CF'::text
                               END ||
                           '-'::text) ||
                       CASE
                           WHEN (length("substring"((crf_number)::text, '([0-9]{2,4})-'::text)) = 2)
                               THEN
                               CASE
                                   WHEN (
                                       ("substring"((crf_number)::text, '([0-9]{2,4})-'::text))::integer <=
                                       40)
                                       THEN (
                                       '20'::text ||
                                       "substring"((crf_number)::text, '([0-9]{2,4})-'::text))
                                   ELSE (
                                       '19'::text ||
                                       "substring"((crf_number)::text, '([0-9]{2,4})-'::text))
                                   END
                           ELSE "substring"((crf_number)::text, '([0-9]{2,4})-'::text)
                           END) ||
                   '-'::text) ||
               regexp_replace(
                       "substring"((crf_number)::text, '-([0-9]{1,8})$'::text),
                       '^0+'::text,
                       ''::text))
           ELSE NULL::text
           END
           as clean_case_number
from doc_sentences;