import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/themes/colors.dart';
import '../cuibt/items_cuibt_cubit.dart';
import 'edit_habit/edit_habit.dart';

class BuildHabitCard extends StatefulWidget {
  const BuildHabitCard({super.key});

  @override
  State<BuildHabitCard> createState() => _BuildHabitCardState();
}

class _BuildHabitCardState extends State<BuildHabitCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          int totalItems = 0;
          int completedItems = 0;

          if (state is ItemsSucceed) {
            totalItems = state.items.length;
            completedItems =
                state.items.where((item) => item.isSelected).length;
            return Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.04,
                  right: MediaQuery.sizeOf(context).width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's habits ",
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.5),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$completedItems/',
                          style: TextStyle(
                            color: AppColors.lightGray.withOpacity(0.5),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '$totalItems Completed Items',
                          style: TextStyle(
                            color: AppColors.lightGray.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      Expanded(
        child: BlocBuilder<ItemsCubit, ItemsState>(
          builder: (context, state) {
            if (state is ItemsSucceed) {
              if (state.items.isEmpty) {
                return const Center(
                  child: Text(
                    "No items were found",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 26),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  context
                                      .read<ItemsCubit>()
                                      .deleteItemsToList(index);
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ]),
                        child: Container(
                          margin: EdgeInsets.all(
                            MediaQuery.sizeOf(context).height * 0.015,
                          ),
                          color: state.items[index].color,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.015,
                                    ),
                                    state.items[index].iconImage,
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.05,
                                    ),
                                    Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      state.items[index].text,
                                      style: GoogleFonts.inter(
                                          fontSize: 20,
                                          color: AppColors.textColor),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditHabitItem()), // الانتقال إلى الصفحة الثانية
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 26,
                                  ),
                                )
                              ],
                            ),
                            leading: InkWell(
                                onTap: () {
                                  setState(() {
                                    state.items[index].isSelected =
                                        !state.items[index].isSelected;
                                  });
                                },
                                child: state.items[index].isSelected == true
                                    ? const Icon(Icons.check_circle)
                                    : const Icon(Icons.circle_outlined)),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(
                child: Text(
                  "No Items Founded",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    ]);
  }
}