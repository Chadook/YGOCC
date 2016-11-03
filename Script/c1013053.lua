--Master Pendulum Kyonshee
function c1013053.initial_effect(c)
	--Pendulum Set
	aux.EnablePendulumAttribute(c)
	--[[	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)]]--
	--Second Attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013053,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,1013053)
	e2:SetTarget(c1013053.atktg)
	e2:SetOperation(c1013053.atkop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1013053,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,1013053)
	e3:SetTarget(c1013053.thtg)
	e3:SetOperation(c1013053.thop)
	c:RegisterEffect(e3)
end
function c1013053.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if chk==0 then return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and tc:IsStatus(STATUS_OPPO_BATTLE)
		and tc:IsOnField() and tc:IsCanBeEffectTarget(e) and tc:IsType(TYPE_NORMAL) and tc:IsRace(RACE_ZOMBIE) end
	Duel.SetTargetCard(tc)
end
function c1013053.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() then
		local ae=Effect.CreateEffect(e:GetHandler())
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ae:SetCode(EFFECT_EXTRA_ATTACK)
		ae:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		ae:SetValue(1)
		tc:RegisterEffect(ae)
	end
end
function c1013053.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c1013053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c1013053.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1013053.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1013053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end