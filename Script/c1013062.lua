--Three-Legged Pendulum Zombie
function c1013062.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)
	--[[	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)]]--
	--Tune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013062,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1013062.tuntg)
	e2:SetOperation(c1013062.tunop)
	c:RegisterEffect(e2)
	--Destroy Replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c1013062.reptg)
	e3:SetValue(c1013062.repval)
	e3:SetOperation(c1013062.repop)
	c:RegisterEffect(e3)
end
function c1013062.tfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_ZOMBIE) and not c:IsType(TYPE_TUNER)
end
function c1013062.tuntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1013062.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1013062.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1013062.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1013062.tunop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c1013062.cfilter(c,tp)
	return c:GetRace()==RACE_ZOMBIE and c:GetPreviousControler()==tp
end
function c1013062.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
		and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO 
			and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and c:GetMaterial():IsExists(c1013062.cfilter,1,nil,tp)
end
function c1013062.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1013062.filter,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(1013062,1))
end
function c1013062.repval(e,c)
	return c1013062.filter(c,e:GetHandlerPlayer())
end
function c1013062.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end