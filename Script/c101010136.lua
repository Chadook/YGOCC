--created & coded by Lyris
--次元盾
function c101010136.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCost(c101010136.cost)
	e1:SetOperation(c101010136.activate)
	c:RegisterEffect(e1)
end
function c101010136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local bd=Duel.GetBattleDamage(tp)
	local dt=math.ceil(bd/500)
	if chk==0 then return bd>0 and Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil)>dt end
	local g=Duel.GetDecktopGroup(tp,dt)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local fg=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	local ct=dt
	if ct>fg then ct=fg end
	e:SetLabel(ct*500)
end
function c101010136.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.ChangeBattleDamage(tp,0) end)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(e:GetLabel())
	e1:SetValue(c101010136.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010136.op(e,re,dam,r,rp,rc)
	if dam>=e:GetLabel() then
		return dam-e:GetLabel()
	else return 0 end
end
