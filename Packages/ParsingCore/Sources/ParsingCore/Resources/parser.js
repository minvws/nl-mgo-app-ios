function parseBundle(input) {
	return  JSON.stringify({
		"label": "PARACETAMOL TABLET 500MG",
		"children": [
			{
				"label": "zib_medication_use.group_general_information",
				"children": [
					{
						"label": "zib_medication_use.date_asserted",
						"display": "2020-07-21",
						"type": "date_time",
						"summary": true
					},
					{
						"label": "zib_medication_use.prescriber",
						"type": "reference",
						"display": null,
						"reference": null,
						"summary": true
					},
					{
						"label": "zib_medication_use.status",
						"display": "completed",
						"type": "code",
						"summary": true
					},
					{
						"label": "zib_medication_use.reason_for_change_or_discontinuation_of_use",
						"type": "codable_concept",
						"display": null
					},
					{
						"label": "zib_medication_use.category",
						"type": "codable_concept",
						"display": [
									"Medicatiegebruik (6 in code systeem urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3)"
									],
						"summary": true
					},
					{
						"label": "zib_medication_use.reason_for_change_or_discontinuation_of_use.value",
						"type": "duration.value",
						"display": null
					},
					{
						"label": "zib_medication_use.reason_for_change_or_discontinuation_of_use.code",
						"type": "duration.code",
						"display": null
					},
					{
						"label": "zib_medication_use.as_agreed_indicator",
						"display": "true",
						"type": "boolean",
						"summary": true
					}
				]
			},
			{
				"label": "zib_medication_use.group_effective_period",
				"children": [
					{
						"label": "zib_medication_use.effective_period.start",
						"type": "period.start",
						"display": "2020-07-21"
					},
					{
						"label": "zib_medication_use.effective_period.end",
						"type": "period.end",
						"display": null
					},
					{
						"label": "zib_medication_use.effective_duration.value",
						"type": "duration.value",
						"display": "30 dag"
					},
					{
						"label": "zib_medication_use.effective_duration.code",
						"type": "duration.code",
						"display": "d in code systeem http://unitsofmeasure.org"
					}
				]
			},
			{
				"label": "zib_medication_use.group_medication",
				"children": [
					{
						"label": "zib_medication_use.identifier",
						"type": "identifier",
						"display": [
							"#MB_01i1#GE_01",
							"1bfa2275-8fdf-11ec-2032-020000000000"
						]
					},
					{
						"label": "zib_medication_use.medication",
						"type": "reference",
						"display": "PARACETAMOL TABLET 500MG",
						"reference": "Medication/zib-Product-02"
					},
					{
						"label": "zib_medication_use.medication_treatment",
						"type": "identifier",
						"display": "#MB_01i1"
					}
				]
			},
			{
				"label": "zib_medication_use.group_details",
				"children": [
					{
						"label": "zib_medication_use.information_source",
						"type": "reference",
						"display": null,
						"reference": null
					},
					{
						"label": "zib_medication_use.subject",
						"type": "reference",
						"display": "XXX_Helleman",
						"reference": "Patient/nl-core-patient-01"
					},
					{
						"label": "zib_medication_use.taken",
						"display": "y",
						"type": "code"
					},
					{
						"label": "zib_medication_use.reason_code",
						"type": "codable_concept",
						"display": null
					},
					{
						"label": "zib_medication_use.note",
						"type": "annotation",
						"display": null
					}
				]
			},
			{
				"label": "zib_instructions_for_use.group",
				"children": [
					{
						"label": "zib_instructions_for_use.as_needed",
						"type": "codable_concept",
						"display": [
									"zo nodig (1137 in code systeem https://referentiemodel.nhg.org/tabellen/nhg-tabel-25-gebruiksvoorschrift#aanvullend-numeriek)"
									]
					},
					{
						"label": "zib_instructions_for_use.dose_quantity.value",
						"type": "quantity.value",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.dose_quantity.code",
						"type": "quantity.code",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.dose_range.low.value",
						"type": "range.low.value",
						"display": "1 Stuk"
					},
					{
						"label": "zib_instructions_for_use.dose_range.low.code",
						"type": "range.low.code",
						"display": "245 in code systeem urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
					},
					{
						"label": "zib_instructions_for_use.dose_range.high.value",
						"type": "range.high.value",
						"display": "2 Stuk"
					},
					{
						"label": "zib_instructions_for_use.dose_range.high.code",
						"type": "range.high.code",
						"display": "245 in code systeem urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
					},
					{
						"label": "zib_instructions_for_use.max_dose_per_period.numerator.value",
						"type": "ratio.numerator.value",
						"display": "6 Stuk"
					},
					{
						"label": "zib_instructions_for_use.max_dose_per_period.numerator.code",
						"type": "ratio.numerator.code",
						"display": "245 in code systeem urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
					},
					{
						"label": "zib_instructions_for_use.max_dose_per_period.denominator.value",
						"type": "ratio.denominator.value",
						"display": "1 dag"
					},
					{
						"label": "zib_instructions_for_use.max_dose_per_period.denominator.code",
						"type": "ratio.denominator.code",
						"display": "d in code systeem http://unitsofmeasure.org"
					},
					{
						"label": "zib_instructions_for_use.rate_ratio.numerator.value",
						"type": "ratio.numerator.value",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_ratio.numerator.code",
						"type": "ratio.numerator.code",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_ratio.denominator.value",
						"type": "ratio.denominator.value",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_ratio.denominator.code",
						"type": "ratio.denominator.code",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_range.low.value",
						"type": "range.low.value",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_range.low.code",
						"type": "range.low.code",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_range.high.value",
						"type": "range.high.value",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_range.high.code",
						"type": "range.high.code",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_quantity.value",
						"type": "quantity.value",
						"display": null
					},
					{
						"label": "zib_instructions_for_use.rate_quantity.code",
						"type": "quantity.code",
						"display": null
					},
					{
						"label": "zib_administration_schedule.duration",
						"type": "duration",
						"display": null
					},
					{
						"label": "zib_administration_schedule.frequency",
						"type": "frequency",
						"display": null
					},
					{
						"label": "zib_administration_schedule.period",
						"type": "period",
						"display": "1 d"
					},
					{
						"label": "zib_administration_schedule.day_of_week",
						"type": "day_of_week",
						"display": null
					},
					{
						"label": "zib_administration_schedule.time_of_day",
						"type": "date_time",
						"display": null
					},
					{
						"label": "zib_administration_schedule.when",
						"type": "when",
						"display": null
					}
				]
			}
		]
	});
}
