class_name GdUnitHtmlReport
extends GdUnitReportSummary

const REPORT_DIR_PREFIX = "report_"

var _report_path :String
var _iteration :int


func _init(report_path :String) -> void:
	_iteration = GdUnitFileAccess.find_last_path_index(report_path, REPORT_DIR_PREFIX) + 1
	_report_path = "%s/%s%d" % [report_path, REPORT_DIR_PREFIX, _iteration]
	DirAccess.make_dir_recursive_absolute(_report_path)


func add_testsuite_report(suite_report :GdUnitTestSuiteReport) -> void:
	_reports.append(suite_report)


@warning_ignore("shadowed_variable")
func add_testcase_report(resource_path :String, suite_report :GdUnitTestCaseReport) -> void:
	for report in _reports:
		if report.resource_path() == resource_path:
			report.add_report(suite_report)


@warning_ignore("shadowed_variable")
func update_test_suite_report(
	resource_path :String,
	duration :int,
	_is_error :bool,
	is_failed: bool,
	_is_warning :bool,
	_is_skipped :bool,
	skipped_count :int,
	failed_count :int,
	orphan_count :int,
	reports :Array = []) -> void:

	for report in _reports:
		if report.resource_path() == resource_path:
			report.set_duration(duration)
			report.set_failed(is_failed, failed_count)
			report.set_skipped(skipped_count)
			report.set_orphans(orphan_count)
			report.set_reports(reports)


@warning_ignore("shadowed_variable")
func update_testcase_report(resource_path :String, test_report :GdUnitTestCaseReport) -> void:
	for report in _reports:
		if report.resource_path() == resource_path:
			report.update(test_report)


func write() -> String:
	var template := GdUnitHtmlPatterns.load_template("res://addons/gdUnit4/src/report/template/index.html")
	var to_write := GdUnitHtmlPatterns.build(template, self, "")
	to_write = apply_path_reports(_report_path, to_write, _reports)
	to_write = apply_testsuite_reports(_report_path, to_write, _reports)
	# write report
	var index_file := "%s/index.html" % _report_path
	FileAccess.open(index_file, FileAccess.WRITE).store_string(to_write)
	GdUnitFileAccess.copy_directory("res://addons/gdUnit4/src/report/template/css/", _report_path + "/css")
	return index_file


func delete_history(max_reports :int) -> int:
	return GdUnitFileAccess.delete_path_index_lower_equals_than(_report_path.get_base_dir(), REPORT_DIR_PREFIX, _iteration-max_reports)


func apply_path_reports(report_dir :String, template :String, report_summaries :Array) -> String:
	#Dictionary[String, Array[GdUnitReportSummary]]
	var path_report_mapping := GdUnitByPathReport.sort_reports_by_path(report_summaries)
	var table_records := PackedStringArray()
	var paths :Array[String] = []
	paths.append_array(path_report_mapping.keys())
	paths.sort()
	for report_path in paths:
		var report := GdUnitByPathReport.new(report_path, path_report_mapping.get(report_path))
		var report_link :String = report.write(report_dir).replace(report_dir, ".")
		table_records.append(report.create_record(report_link))
	return template.replace(GdUnitHtmlPatterns.TABLE_BY_PATHS, "\n".join(table_records))


func apply_testsuite_reports(report_dir :String, template :String, test_suite_reports :Array[GdUnitReportSummary]) -> String:
	var table_records := PackedStringArray()
	for report in test_suite_reports:
		var report_link :String = report.write(report_dir).replace(report_dir, ".")
		table_records.append(report.create_record(report_link))
	return template.replace(GdUnitHtmlPatterns.TABLE_BY_TESTSUITES, "\n".join(table_records))


func iteration() -> int:
	return _iteration
