local network = {}
local wirered = defines.wire_type.red
local wiregreen = defines.wire_type.green
local mathmin = math.min
local mathmax = math.max
local mathfloor = math.floor

network.metatable = {__index = network}

function network.new(index, name)
    local module = {
        index = index,
        name = name,
        transmitter = {},
        reciever = {}
    }

    setmetatable(module, network.metatable)

    return module
end

function network:add(entity)
    self[entity.name:sub(10)][tostring(entity.unit_number)] = entity
end

function network:remove(entity)
    self[entity.name:sub(10)][tostring(entity.unit_number)] = nil
end

function network:update()
    if next(self.transmitter) and next(self.reciever) then
        local signaltable = {}
        local signals = {}
        local index_number = 1
        local parameters = {}
        
        for _, entity in pairs(self.transmitter) do
            if entity.valid then
                signals = entity.get_circuit_network(wirered)
                
                if signals and signals.signals then
                    for _, signal in pairs(signals.signals) do
                        if signal then
                            local signal2 = signal.signal
                            local signaltype = signal2.type
                            local signalname = signal2.name
                            local signalcount = signal.count

                            if not signaltable[signaltype] then
                                signaltable[signaltype] = {}
                            end

                            local signaltabletype = signaltable[signaltype]

                            if signaltabletype[signalname] then
                                signaltabletype[signalname].count = signaltabletype[signalname].count + signalcount
                            else
                                signaltabletype[signalname] = { signal = signal2, count = signalcount }
                            end
                        end
                    end
                end

                signals = entity.get_circuit_network(wiregreen)

                if signals and signals.signals then
                    for _, signal in pairs(signals.signals) do
                        if signal then
                            local signal2 = signal.signal
                            local signaltype = signal2.type
                            local signalname = signal2.name
                            local signalcount = signal.count

                            if not signaltable[signaltype] then
                                signaltable[signaltype] = {}
                            end

                            local signaltabletype = signaltable[signaltype]

                            if signaltabletype[signalname] then
                                signaltabletype[signalname].count = signaltabletype[signalname].count + signalcount
                            else
                                signaltabletype[signalname] = {signal = signal2, count = signalcount}
                            end
                        end
                    end
                end
            end
        end

        for _, signals2 in pairs(signaltable) do
            for _, signals3 in pairs(signals2) do
                if index_number < 1000 then
                    parameters[index_number] = {index = index_number, signal = signals3.signal, count = mathmin(2147483647, mathmax(-2147483647, mathfloor(signals3.count or 1)))}
                    index_number = index_number + 1
                else
                    break
                end
            end
        end

        for _, entity in pairs(self.reciever) do
            if entity.valid then
                entity.get_or_create_control_behavior().parameters = {parameters = parameters}
            end
        end
    end
end

return network