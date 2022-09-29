package uz.udevs.udevs_video_player.adapters

import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.recyclerview.widget.RecyclerView
import uz.udevs.udevs_video_player.R

class QualitySpeedAdapter(
    private val currentValue: String,
    private val items: ArrayList<String>,
    private var onClickListener: OnClickListener,
) :
    RecyclerView.Adapter<QualitySpeedAdapter.Vh>() {

    private var hasSetFocus = false

    inner class Vh(view: View) : RecyclerView.ViewHolder(view) {
        var button: Button = view.findViewById(R.id.quality_speed_item)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Vh {
        val view: View =
            LayoutInflater.from(parent.context).inflate(R.layout.quality_speed_item, parent, false)
        val holder = Vh(view)
        holder.itemView.setOnClickListener {
            val position = holder.adapterPosition
            onClickListener.onClick(position)
        }
        holder.itemView.setOnFocusChangeListener { _, b ->
            if (b) {
                holder.button.setBackgroundResource(R.drawable.focus_border)
            } else {
                holder.button.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        return holder
    }

    override fun onBindViewHolder(holder: Vh, position: Int) {
        val item = items[position]
        holder.button.text = item
        if (currentValue == item) {
            holder.button.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.ic_check, 0)
        }
        if (!hasSetFocus) {
            holder.itemView.requestFocus()
            hasSetFocus = true
        }
    }

    override fun getItemCount(): Int {
        return items.size
    }

    interface OnClickListener {
        fun onClick(position: Int)
    }
}