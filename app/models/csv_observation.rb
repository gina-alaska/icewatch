class CsvObservation
  include ActiveModel::Model
  include Converters::JSON

  attr_accessor :date, :po, :ao, :lat, :lon, :tc, :ow, :ot, :th, :ppc, :pt, :pz,
                :pf, :psy, :psh, :ptop, :ptopc, :prh, :pold, :pcs, :psc, :pmpc,
                :pmpd, :pmpp, :pmpt, :pmpf, :pmbt, :pmdi, :pmri, :pa, :psd, :pad,
                :pal, :spc, :st, :sz, :sf, :ssy, :ssh, :stop, :stopc, :srh, :sold,
                :scs, :ssc, :smpc, :smpd, :smpp, :smpt, :smpf, :smbt, :smdi, :smri,
                :sa, :ssd, :sad, :sal, :tpc, :tt, :tz, :tf, :tsy, :tsh, :ttop,
                :ttopc, :trh, :told, :tcs, :tsc, :tmpc, :tmpd, :tmpp, :tmpt, :tmpf,
                :tmbt, :tmdi, :tmri, :ta, :tsd, :tad, :tal, :wx, :v, :hy, :hv,
                :hh, :my, :mv, :mh, :ly, :lv, :lh, :tcc, :ws, :wd, :at, :wt,
                :relh, :ap, :shp, :shs, :shh, :sha, :fn, :fc, :photo, :note0,
                :note1, :note2, :comments

  def initialize(params = {})
    params.transform_keys! { |k| k.to_s.downcase }
    super
  end

  def method_missing *args
    super unless args.first =~ /=$/
    field = args.first.to_s.chomp('=').upcase

    errors.add(:base, "Unknown field: '#{field}'")
  end

  def to_observation_json
    {
      latitude: lat,
      longitude: lon,
      observed_at: date,
      primary_observer: { name: po },
      additional_observers: additional_observers,
      ship: {
        power: shp,
        speed: shs,
        heading: shh,
        ship_activity_lookup_code: sha
      },
      faunas: faunas,
      ice: {
        total_concentration: tc,
        thin_ice_lookup_code: ot,
        thick_ice_lookup_code: th,
        open_water_lookup_code: ow
      },
      primary_ice_observation: {
        partial_concentration: ppc,
        ice_lookup_code: pt,
        thickness: pz,
        floe_size_lookup_code: pf,
        sediment_lookup_code: psd,
        algae_lookup_code: pa,
        algae_density_lookup_code: pad,
        algae_location_lookup_code: pal,
        snow_lookup_code: psy,
        snow_thickness: psh,
        melt_pond: {
          surface_coverage: pmpc,
          max_depth_lookup_code: pmpd,
          pattern_lookup_code: pmpp,
          surface_lookup_code: pmpt,
          freeboard: pmpf,
          bottom_type_lookup_code: pmbt,
          dried_ice: pmdi,
          rotten_ice: pmri
        },
        topography: {
          topography_lookup_code: ptop,
          old: pold,
          consolidated: pcs,
          snow_covered: psc,
          concentration: ptopc,
          ridge_height: prh
        }
      },
      secondary_ice_observation: {
        partial_concentration: spc,
        ice_lookup_code: st,
        thickness: sz,
        floe_size_lookup_code: sf,
        sediment_lookup_code: ssd,
        algae_lookup_code: sa,
        algae_density_lookup_code: sad,
        algae_location_lookup_code: sal,
        snow_lookup_code: ssy,
        snow_thickness: ssh,
        melt_pond: {
          surface_coverage: smpc,
          max_depth_lookup_code: smpd,
          pattern_lookup_code: smpp,
          surface_lookup_code: smpt,
          freeboard: smpf,
          bottom_type_lookup_code: smbt,
          dried_ice: smdi,
          rotten_ice: smri
        },
        topography: {
          topography_lookup_code: stop,
          old: sold,
          consolidated: scs,
          snow_covered: ssc,
          concentration: stopc,
          ridge_height: srh
        }
      },
      tertiary_ice_observation: {
        partial_concentration: tpc,
        ice_lookup_code: tt,
        thickness: tz,
        floe_size_lookup_code: tf,
        sediment_lookup_code: tsd,
        algae_lookup_code: ta,
        algae_density_lookup_code: tad,
        algae_location_lookup_code: tal,
        snow_lookup_code: tsy,
        snow_thickness: tsh,
        melt_pond: {
          surface_coverage: tmpc,
          max_depth_lookup_code: tmpd,
          pattern_lookup_code: tmpp,
          surface_lookup_code: tmpt,
          freeboard: tmpf,
          bottom_type_lookup_code: tmbt,
          dried_ice: tmdi,
          rotten_ice: tmri
        },
        topography: {
          topography_lookup_code: ttop,
          old: told,
          consolidated: tcs,
          snow_covered: tsc,
          concentration: ttopc,
          ridge_height: trh
        }
      },
      meteorology: {
        visibility_lookup_code: v,
        weather_lookup_code: wx,
        total_cloud_cover: tcc,
        wind_speed: ws,
        wind_direction: wd,
        air_temperature: at,
        water_temperature: wt,
        relative_humidity: relh,
        air_pressure: ap,
        high_cloud: {
          cover: hv,
          height: hh,
          cloud_lookup_code: hy
        },
        medium_cloud: {
          cover: mv,
          height: mh,
          cloud_lookup_code: my
        },
        low_cloud: {
          cover: lv,
          height: lh,
          cloud_lookup_code: ly
        }
      },
      notes: [{ text: note0 }, { text: note1 }, { text: note2 }],
      comments: split_comments
    }
  end

  private

  def faunas
    fn ||= ''
    fc ||= ''
    fn.split(',').zip(fc.split(',')).map { |f| { name: f.first, count: f.last } }
  end

  def additional_observers
    return nil if ao.nil?
    ao.split(':').map { |n| { name: n } }
  end

  def split_comments
    return nil if comments.nil?
    comments.split('//').map { |c| comment_to_hash(c) } if comments.present?
  end

  def comment_to_hash(line)
    comment, person = line.split(' -- ')
    { person: { name: person }, text: comment }
  end
end
