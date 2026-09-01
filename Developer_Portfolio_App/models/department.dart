import 'package:flutter/material.dart';

class FacultyMember {
  final String name;
  final String designation;
  final String specialization;
  final String email;

  const FacultyMember({
    required this.name,
    required this.designation,
    required this.specialization,
    required this.email,
  });
}

class CourseInfo {
  final String code;
  final String title;
  final String credits;
  final String semester;

  const CourseInfo({
    required this.code,
    required this.title,
    required this.credits,
    required this.semester,
  });
}

class DepartmentFacility {
  final String name;
  final String description;
  final IconData icon;

  const DepartmentFacility({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class Department {
  final String name;
  final String code;
  final String description;
  final String email;
  final String phone;
  final String location;
  final List<FacultyMember> faculty;
  final List<CourseInfo> courses;
  final List<DepartmentFacility> facilities;

  const Department({
    required this.name,
    required this.code,
    required this.description,
    required this.email,
    required this.phone,
    required this.location,
    required this.faculty,
    required this.courses,
    required this.facilities,
  });
}
