import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_config.dart';
import 'auth_state.dart';

class TutorApiService {
    static final TutorApiService instance = TutorApiService._internal();
    TutorApiService._internal(); 

    Future<Map<String, dynamic>> getMyOffers() async {
        try {
            final uri = Uri.parse('${AppConfig.apiUrl}/user/tutor/offer/mine');

            final response = await http.get(
                uri,
                headers: AuthState.instance.authHeaders,
            );

            if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                return {'success': true, 'data': data};
            }else {
                final error = jsonDecode(response.body);
                return {'success': false, 'message': error['message'] ?? 'Failed to load offers'};
            }
        } catch (e) {
            return {'success': false, 'message': 'An error occurred while loading offers'};
        }
    }

    Future<Map<String, dynamic>> createOffer({
        required String title,
        required String description,
        required int durationMinutes,
        required int coinsPerHour,
    }) async {
        try {
            final uri = Uri.parse('${AppConfig.apiUrl}/user/tutor/offer');

            final response = await http.post(
                uri,
                headers: {
                    ...AuthState.instance.authHeaders,
                    'Content-Type': 'application/json',
                },
                body: jsonEncode({
                    'title': title,
                    'description': description,
                    'duration_minutes': durationMinutes,
                    'coins_per_hour': coinsPerHour,
                }),
            );

            if (response.statusCode == 201 || response.statusCode == 200) {
                return {'success': true};
            } else {
                final error = jsonDecode(response.body);
                return {
                    'success': false,
                    'message': error['message'] ?? 'Failed to create a new class',
                };
            }
        } catch (e) {
            return {
                'success': false,
                'message': 'An error occurred while creating a new class',
            };
        }
    }

    Future<Map<String, dynamic>> addAvailability({
        required String dayOfWeek,
        required String startTime,
        required String endTime,
    }) async {
        try {
        final requestUrl = Uri.parse('${AppConfig.apiUrl}/user/tutor/availability');
        
        final response = await http.post(
            requestUrl,
            headers: {
            ...AuthState.instance.authHeaders,
            'Content-Type': 'application/json',
            },
            body: jsonEncode({
            'day_of_week': dayOfWeek,
            'start_time': startTime,
            'end_time': endTime,
            }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
            return {'success': true};
        } else {
            final error = jsonDecode(response.body);
            return {'success': false, 'message': error['message'] ?? 'Gagal menambah jadwal'};
        }
        } catch (e) {
        return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
        }
    }

    Future<Map<String, dynamic>> getTutorBookings({String? status}) async {
        try {
            var url = '${AppConfig.apiUrl}/booking/tutor';
            if (status != null) {
                url += '?status=$status';
            }
            final uri = Uri.parse(url);

            final response = await http.get(
                uri,
                headers: AuthState.instance.authHeaders,
            );

            if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                return {'success': true, 'data': data};
            } else {
                final error = jsonDecode(response.body);
                return {'success': false, 'message': error['message'] ?? 'Failed to load bookings'};
            }
        } catch (e) {
            return {'success': false, 'message': 'A network error has occurred: $e'};
        }
    }

    Future<Map<String, dynamic>> acceptBooking(String bookingId) async {
        try {
            final uri = Uri.parse('${AppConfig.apiUrl}/booking/$bookingId/confirm');
            final response = await http.patch(uri, headers: AuthState.instance.authHeaders);
            
            if (response.statusCode == 200) {
                return {'success': true};
            } else {
                final error = jsonDecode(response.body);
                return {'success': false, 'message': error['message'] ?? 'Failed to accept booking'};
            }
        } catch (e) {
            return {'success': false, 'message': 'Network error: $e'};
        }
    }

    Future<Map<String, dynamic>> declineBooking(String bookingId) async {
        try {
            final uri = Uri.parse('${AppConfig.apiUrl}/booking/$bookingId/decline');
            final response = await http.patch(uri, headers: AuthState.instance.authHeaders);
            
            if (response.statusCode == 200) {
                return {'success': true};
            } else {
                final error = jsonDecode(response.body);
                return {'success': false, 'message': error['message'] ?? 'Failed to decline booking'};
            }
        } catch (e) {
            return {'success': false, 'message': 'Network error: $e'};
        }
    }

    Future<Map<String, dynamic>> completeBooking(String bookingId) async {
        try {
            final uri = Uri.parse('${AppConfig.apiUrl}/booking/$bookingId/complete');
            final response = await http.patch(uri, headers: AuthState.instance.authHeaders);
            
            if (response.statusCode == 200) {
                return {'success': true};
            } else {
                final error = jsonDecode(response.body);
                return {'success': false, 'message': error['message'] ?? 'Failed to complete booking'};
            }
        } catch (e) {
            return {'success': false, 'message': 'Network error: $e'};
        }
    }
}