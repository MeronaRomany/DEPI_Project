import 'package:depi_project/features/travel/presentation/cubit/travel_cubit.dart';
import 'package:depi_project/features/travel/presentation/cubit/travel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/app_color.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => context.read<TravelCubit>().searchLocation(value),
        decoration: InputDecoration(
          hintText: 'Search for a city (e.g. Paris)...',
          hintStyle: TextStyle(color: Appcolor.kgrey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Appcolor.kgrey),
          suffixIcon: BlocBuilder<TravelCubit, TravelState>(
            buildWhen: (previous, current) =>
                previous.isSearchingLocation != current.isSearchingLocation,
            builder: (context, state) {
              return state.isSearchingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Icon(Icons.tune, color: Appcolor.kgrey);
            },
          ),
          filled: true,
          fillColor: Appcolor.kWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Appcolor.kgrey.withAlpha(40)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Appcolor.kPrimary),
          ),
        ),
      ),
    );
  }
}
