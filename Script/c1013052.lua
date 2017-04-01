--Temple of Skulls
function c1013052.initial_effect(c)
	--Pendulum Set
	aux.EnablePendulumAttribute(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1013052,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,1013052)
	e1:SetTarget(c1013052.destg)
	e1:SetOperation(c1013052.desop)
	c:RegisterEffect(e1)
	--Add to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013052,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c1013052.thtg)
	e2:SetOperation(c1013052.thop)
	c:RegisterEffect(e2)
end
function c1013052.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttackTarget()
	local ac=Duel.GetAttacker()
	if chk==0 then return bc~=nil and bc:IsControler(tp) and ac:IsControler(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ac,1,0,0)
end
function c1013052.desop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	if ac:IsRelateToBattle() then
		Duel.Destroy(ac,REASON_EFFECT)
	end
end
function c1013052.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function c1013052.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c1013052.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c1013052.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1013052.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end